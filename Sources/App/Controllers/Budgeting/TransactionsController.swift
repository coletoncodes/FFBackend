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
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let transactionRoutes = routes.grouped("transactions")
        // Get's the non deleted transactions for a given plaid bank account
        transactionRoutes.get("non-deleted", ":plaidItemAccessToken", use: getNonDeletedTransactions)
    }
}

// MARK: - Public Requests
extension TransactionsController {
    
    func getNonDeletedTransactions(req: Request) async throws -> HTTPStatus {
        do {
            guard let plaidItemAccessToken = req.parameters.get("plaidItemAccessToken", as: String.self) else {
                throw Abort(.badRequest, reason: "No plaidItemAccessToken in URL.")
            }
            
            let plaidSyncTransactionsResponse = try await plaidAPI.syncTransactions(req: req, for: plaidItemAccessToken)
            // TODO: Return response after saving to database.
            return .ok
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
        }
    }
}
