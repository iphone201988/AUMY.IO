import Foundation

struct StoredKeys<Value> {
    
    let name: String
    
    init(_ name: Keyname) {
        self.name = name.rawValue
    }
    
    static var userID: StoredKeys<String> {
        return StoredKeys<String>(Keyname.userID)
    }
    
    static var email: StoredKeys<String> {
        return StoredKeys<String>(Keyname.email)
    }
    
    static var deviceToken: StoredKeys<String> {
        return StoredKeys<String>(Keyname.deviceToken)
    }
    
    static var accessToken: StoredKeys<String> {
        return StoredKeys<String>(Keyname.accessToken)
    }
}
