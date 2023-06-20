//
//  Container.swift
//  
//
//  Created by Coleton Gorecke on 6/20/23.
//

import Factory
import Foundation

extension Container {
    // MARK: - Providers
    var accessTokenProvider: Factory<AccessTokenProviding> {
        self { AccessTokenProvider() }
            .graph
    }
    
    var refreshTokenProvider: Factory<RefreshTokenProviding> {
        self { RefreshTokenProvider() }
            .graph
    }
    
    // MARK: - Stores
    var refreshTokenStore: Factory<RefreshTokenStore> {
        self { RefreshTokenRepository() }
            .graph
    }
    
    var userStore: Factory<UserStore> {
        self { UserRepository() }
            .graph
    }
}
