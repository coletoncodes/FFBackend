//
//  TransactionsController.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Factory
import FFAPI
import Vapor

final class TransactionsController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.plaidAPIService) private var plaidAPI
    @Injected(\.transactionProvider) private var provider
    @Injected(\.bankAccountStore) private var bankAccountStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let transactionRoutes = routes.grouped("transactions")
        // Get's the non deleted transactions for a given plaid bank account
        transactionRoutes.get("non-deleted", ":institutionID", use: getTransactions)
    }
}

// MARK: - Public Requests
extension TransactionsController {
    
    func getTransactions(req: Request) async throws -> HTTPStatus {
        do {
            guard let institutionID = req.parameters.get("institutionID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No institutionID in URL.")
            }
            
//            guard let bankAccount = try await bankAccountStore.getBankAccount(matching: bankAccountID, on: req.db) else {
//                throw Abort(.notFound, reason: "No bank account found for the given id")
//            }
//            
//            let response = try await plaidAPI.syncTransactions(req: req, for: bankAccount.accountID)
//            
//            let ffTransactions = response.added.map { addedTransaction in
//                FFTransaction(
//                    id: .init(),
//                    bankAccountID: <#T##UUID#>,
//                    name: <#T##String#>,
//                    amount: <#T##Double#>,
//                    date: <#T##Date#>
//                )
//            }
//            
//            try await provider.save(<#T##transactions: [FFTransaction]##[FFTransaction]#>, database: <#T##Database#>)
            // TODO: Return response after saving to database.
            return .ok
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
        }
    }
}
