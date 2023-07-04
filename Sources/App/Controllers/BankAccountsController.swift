//
//  BankAccountsController.swift
//  
//
//  Created by Coleton Gorecke on 6/20/23.
//

import Factory
import Vapor

final class BankAccountsController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.bankAccountStore) private var bankAccountStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let bankAccountRoutes = routes.grouped("bank-accounts")
        bankAccountRoutes.get("", use: getBankAccounts)
    }
}

// MARK: - Public Requests
extension BankAccountsController {
    // TODO: Return BankAccount objects
    func getBankAccounts(req: Request) async throws -> [String] {
        
        return []
    }
}
