//
//  Container.swift
//  
//
//  Created by Coleton Gorecke on 6/20/23.
//

import Factory
import Foundation
import JWT

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
    
    var plaidAccessTokenStore: Factory<PlaidAccessTokenStore> {
        self { PlaidAccessTokenRepository() }
            .graph
    }
    
    var institutionStore: Factory<InstitutionStore> {
        self { InstitutionRepository() }
            .graph
    }
    
    var bankAccountStore: Factory<BankAccountStore> {
        self { BankAccountRepository() }
            .graph
    }
    
    // MARK: - Utilities
    // TODO: Inject from environment
    var jwtSigner: Factory<JWTSigner> {
        self { JWTSigner.hs256(key: "your-secret-key")
        }
        .graph
    }
}
