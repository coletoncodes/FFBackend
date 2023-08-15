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
    @Injected(\.institutionStore) private var institutionStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let transactionRoutes = routes.grouped("transactions")
        // Get's the non deleted transactions for a given plaid bank account
        transactionRoutes.get("non-deleted", ":institutionID", use: getTransactions)
    }
}

// MARK: - Public Requests
extension TransactionsController {
    
    func getTransactions(req: Request) async throws -> FFGetTransactionsResponse {
        do {
            guard let institutionID = req.parameters.get("institutionID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No institutionID in URL.")
            }
            
            let institution = try await institutionStore.findInstitutionMatching(institutionID, on: req.db)
            
            let response = try await plaidAPI.syncTransactions(req: req, for: institution)
            
            let ffTransactions = try response.added.map { addedTransaction in
                FFTransaction(
                    id: .init(),
                    institutionID: try institution.requireID(),
                    name: addedTransaction.name,
                    amount: addedTransaction.amount,
                    date: try CustomDateFormatter.toRoundedDate(from: addedTransaction.date)
                )
            }
            
            try await provider.save(ffTransactions, database: req.db)
            let savedTransactions = try await provider.getTransactionsForInstitution(matching: try institution.requireID(), database: req.db)
            return FFGetTransactionsResponse(transactions: savedTransactions)
        } catch {
            req.logger.log(level: .error, "Failed to get Transactions. Error: \(error)")
            throw Abort(.internalServerError, reason: "Failed to get Transactions.", error: error)
        }
    }
}
