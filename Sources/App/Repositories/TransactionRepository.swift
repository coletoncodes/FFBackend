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
    func getTransactions(for bankAccountID: BankAccount.IDValue, on db: Database) async throws -> [Transaction]
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
    
    // TODO: It's possible this will return the transactions for multiple users..
    func getTransactions(
        for bankAccountID: BankAccount.IDValue,
        on db: Database
    ) async throws -> [Transaction] {
        return try await Transaction
            .query(on: db)
            .filter(\.$bankAccount.$id == bankAccountID)
            .all()
    }
}
