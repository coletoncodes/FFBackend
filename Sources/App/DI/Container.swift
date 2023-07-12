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
    
    var userProvider: Factory<UserProviding> {
        self { UserProvider() }
            .graph
    }
    
    var institutionProvider: Factory<InstitutionsProviding> {
        self { InstitutionsProvider() }
            .graph
    }
    
    var budgetCategoryProvider: Factory<BudgetCategoryProviding> {
        self { BudgetCategoryProvider() }
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
    
    var budgetCategoryStore: Factory<BudgetCategoryStore> {
        self { BudgetCategoryRepository() }
            .graph
    }
    
    var budgetItemStore: Factory<BudgetItemStore> {
        self { BudgetItemRepository() }
            .graph
    }
    
    var transactionStore: Factory<TransactionStore> {
        self { TransactionRepository() }
            .graph
    }
    
    // MARK: - Utilities
    // TODO: Inject from environment
    var jwtSigner: Factory<JWTSigner> {
        self { JWTSigner.hs256(key: "your-secret-key") }
            .graph
    }
}
