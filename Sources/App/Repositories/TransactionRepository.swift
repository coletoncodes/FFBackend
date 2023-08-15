//
//  TransactionRepository.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Fluent
import Vapor

protocol TransactionStore {
    func save(_ transactions: [Transaction], on db: Database) async throws
    func getTransactionsForInstitution(
        matching id: Institution.IDValue,
        on db: Database
    ) async throws -> [Transaction]
}

final class TransactionRepository: TransactionStore {
    // MARK: - Interface
    func save(_ transactions: [Transaction], on db: Database) async throws {
        for transaction in transactions {
            if let existing = try await Transaction
                .query(on: db)
                .filter(\.$id == transaction.requireID())
                .first() {
                existing.amount = transaction.amount
                existing.name = transaction.name
                existing.date = transaction.date
                try await existing.save(on: db)
            } else {
                try await transaction.save(on: db)
            }
        }
    }
    
    func getTransactionsForInstitution(
        matching id: Institution.IDValue,
        on db: Database
    ) async throws -> [Transaction] {
        return try await Transaction
            .query(on: db)
            .filter(\.$institution.$id == id)
            .all()
    }
}
