import Foundation
import Security

// You might want to update this to be something descriptive for your app.
fileprivate var service: String = ""

public final class Keychain {
    
    public static let shared: Keychain = Keychain()
    
    private init() {}
    
    public func changeServiceName(_ serviceName: String) {
        service = serviceName
    }
    
    /// Does a certain item exist?
    public func exists(account: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: false,
            ] as NSDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Adds an item to the keychain.
    public func add(value: Data, account: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            // Allow background access:
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
            ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Updates a keychain item.
    public func update(value: Data, account: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary, [
            kSecValueData: value,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Stores a keychain item.
    public func set(value: Data, account: String) throws {
        if try exists(account: account) {
            try update(value: value, account: account)
        } else {
            try add(value: value, account: account)
        }
    }
    
    // If not present, returns nil. Only throws on error.
    public func get(account: String) throws -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
            ] as NSDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Delete a single item.
    public func delete(account: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Delete all items for my app. Useful on eg logout.
    public func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    public enum Errors: Error {
        case keychainError
    }
    
}
