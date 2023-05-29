//
//  Container+.swift
//  
//
//  Created by Coleton Gorecke on 5/29/23.
//

import Factory
import Foundation

extension Container {
    
    var accessTokenProvider: Factory<AccessTokenProviding> {
        self { AccessTokenProvider() }
            .scope(.graph)
    }
    
    var refreshTokenProvider: Factory<RefreshTokenProviding> {
        self { RefreshTokenProvider() }
            .scope(.graph)
    }
    
    var userStore: Factory<UserStore> {
        self { UserRepository() }
            .scope(.graph)
    }
    
    var refreshTokenStore: Factory<RefreshTokenStore> {
        self { RefreshTokenRepository() }
            .scope(.graph)
    }
}
