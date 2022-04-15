# SimpleKeychain

Simple Keychain Wrapper Library

# Installation

```bash
https://github.com/paigeshin/SimpleKeychain/edit/master/README.md
```

# Optional

You can set service name by doing this

```swift
Keychain.shared.changeServiceName("My App Project")
```

# Usage

```swift
// set
guard let data: Data = "any string".data(using: .utf8) else { return }
try? Keychain.shared.set(value: data, account: "any string key")

// get 
let value = try? Keychain.shared.get(account: "any string key")
print(String(data: value!, encoding: .utf8))
```
