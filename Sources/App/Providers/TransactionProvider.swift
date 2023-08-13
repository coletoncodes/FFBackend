//
//  File.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

final class TransactionProvider {
    // MARK: - Dependencies
    @Injected(\.transactionStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func save(_ transactions: [FFTransaction], database: Database) async throws {
        let transactions = transactions.map { Transaction(from: $0) }
        try await store.save(transactions, on: database)
    }
    
    func getTransactions(for id: FFBankAccount.ID, database: Database) async throws -> [FFTransaction] {
        return try await store.getTransactions(for: id, on: database)
            .map { try FFTransaction(from: $0) }
    }
}
