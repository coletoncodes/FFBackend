//
//  TransactionRepository.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import Fluent

protocol TransactionStore {
    func getTransactions(budgetItemID: UUID, on db: Database) async throws -> [Transaction]
    func save(_ transaction: Transaction, on db: Database) async throws
    func save(_ transactions: [Transaction], on db: Database) async throws
    func delete(_ transaction: Transaction, on db: Database) async throws
}

final class TransactionRepository: TransactionStore {
    
    init() {}
    
    // MARK: - Interface
    func getTransactions(budgetItemID: UUID, on db: Database) async throws -> [Transaction] {
        try await Transaction
            .query(on: db)
            .filter(\.$budgetItem.$id == budgetItemID)
            .all()
    }
    
    func save(_ transaction: Transaction, on db: Database) async throws {
        try await transaction.save(on: db)
    }
    
    func save(_ transactions: [Transaction], on db: Database) async throws {
        for transaction in transactions {
            try await save(transaction, on: db)
        }
    }
    
    func delete(_ transaction: Transaction, on db: Database) async throws {
        try await transaction.delete(on: db)
    }
}
