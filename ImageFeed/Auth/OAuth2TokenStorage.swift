//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 14.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    var token: String?  {
        get {
            UserDefaults.standard.string(forKey: OAuth2Service.OAuthTokenResponseBody.CodingKeys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OAuth2Service.OAuthTokenResponseBody.CodingKeys.accessToken.rawValue)
        }
    }
    
}
