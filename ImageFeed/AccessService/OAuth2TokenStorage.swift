

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let key = "access_token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: key)
        }
    }
}
