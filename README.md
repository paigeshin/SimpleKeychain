# SimpleKeychain

Simple Keychain Wrapper Library

# Optional

You can set service name by doing this

```swift
Keychain.shared.changeServiceName("My App Roject")
```

# Usage

```swift
// set 
guard let data: Data = "any string".data(using: .utf8) else { return }
try? keychainWrapper.set(value: data, account: "any string key")

// get 
try? keychainWrapper.get(account: "any string key")
```
