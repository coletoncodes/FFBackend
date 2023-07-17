//
//  TransactionProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Factory
import FFAPI
import Foundation
import FluentKit

protocol TransactionProviding {
    func getTransactions(budgetItemID: UUID, database: Database) async throws -> [FFTransaction]
    func delete(transaction: FFTransaction, database: Database) async throws
    func save(transaction: FFTransaction, database: Database) async throws
    func save(transactions: [FFTransaction], database: Database) async throws
}

final class TransactionProvider: TransactionProviding {
    // MARK: - Dependencies
    @Injected(\.transactionStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func getTransactions(
        budgetItemID: UUID,
        database: Database
    ) async throws -> [FFTransaction] {
        return try await store.getTransactions(budgetItemID: budgetItemID, on: database)
            .map { try FFTransaction(from: $0) }
    }
    
    func delete(transaction: FFTransaction, database: Database) async throws {
        let transaction = Transaction(from: transaction)
        try await store.delete(transaction, on: database)
    }
    
    func save(transaction: FFTransaction, database: Database) async throws {
        let transaction = Transaction(from: transaction)
        try await store.save(transaction, on: database)
    }
    
    func save(transactions: [FFTransaction], database: Database) async throws {
        for transaction in transactions {
            try await save(transaction: transaction, database: database)
        }
    }
}

