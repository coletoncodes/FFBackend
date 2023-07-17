//
//  TransactionsController.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation
import FFAPI
import Factory
import Vapor

final class TransactionsController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.transactionProvider) private var provider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let transactionRoutes = routes.grouped("transactions")
        transactionRoutes.get("", use: getTransactions)
        transactionRoutes.post("", use: postTransactions)
        transactionRoutes.delete("", use: deleteTransaction)
    }
}

// MARK: - Public Requests
extension TransactionsController {
    
    func getTransactions(req: Request) async throws -> FFGetTransactionsResponse {
        do {
            let body = try req.content.decode(FFGetTransactionsRequestBody.self)
            let transactions = try await provider.getTransactions(budgetItemID: body.budgetItemID, database: req.db)
            return FFGetTransactionsResponse(transactions: transactions)
        } catch {
            throw Abort(.badGateway, reason: "Failed to get transactions. Error: \(error)")
        }
    }
    
    func postTransactions(req: Request) async throws -> FFPostTransactionsResponse {
        do {
            let body = try req.content.decode(FFPostTransactionsRequestBody.self)
            try await provider.save(transactions: body.transactions, database: req.db)
            let transactions = try await provider.getTransactions(budgetItemID: body.budgetItemID, database: req.db)
            return FFPostTransactionsResponse(transactions: transactions)
        } catch {
            throw Abort(.badGateway, reason: "Failed to post transactions. Error: \(String(reflecting: error))")
        }
    }
    
    func deleteTransaction(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFDeleteTransactionRequestBody.self)
            try await provider.delete(transaction: body.transaction, database: req.db)
            return .ok
        } catch {
            throw Abort(.badGateway, reason: "Failed to delete transactions. Error: \(error)")
        }
    }
}
