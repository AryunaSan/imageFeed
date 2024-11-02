

import Foundation

final class OAuth2TokenStorage {
    
    private let key = "access_token"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
