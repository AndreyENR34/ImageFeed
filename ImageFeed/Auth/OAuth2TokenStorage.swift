//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 14.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    var token: String?  {
        get {
            KeychainWrapper.standard.string(forKey: "Auth token") ?? ""
        }
        
        set {
            KeychainWrapper.standard.set(newValue!, forKey: "Auth token" )
        }
    }
    
}
