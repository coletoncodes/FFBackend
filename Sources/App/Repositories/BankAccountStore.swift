//
//  BankAccountStore.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Vapor

protocol BankAccountStore {
    func save(_ account: BankAccount, on db: Database) async throws
    func save(_ accounts: [BankAccount], on db: Database) async throws
    func findAccount(by ID: UUID, on db: Database) async throws -> BankAccount?
    func delete(_ account: BankAccount, on db: Database) async throws
}

final class BankAccountRepository: BankAccountStore {
    func save(_ account: BankAccount, on db: Database) async throws {
        try await account.save(on: db)
    }
    
    func save(_ accounts: [BankAccount], on db: Database) async throws {
        for account in accounts {
            try await account.save(on: db)
        }
    }
    
    func findAccount(by ID: UUID, on db: Database) async throws -> BankAccount? {
        try await BankAccount.query(on: db)
            .filter(\.$id == ID)
            .first()
    }
    
    func delete(_ account: BankAccount, on db: Database) async throws {
        try await account.delete(on: db)
    }
}
