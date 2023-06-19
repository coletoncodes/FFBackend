//
//  AccountStore.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Vapor

protocol AccountStore {
    func save(_ account: Account, on db: Database) async throws
    func save(_ accounts: [Account], on db: Database) async throws
    func findAccount(by ID: UUID, on db: Database) async throws -> Account?
    func delete(_ account: Account, on db: Database) async throws
}

final class AccountRepository: AccountStore {
    func save(_ account: Account, on db: Database) async throws {
        try await account.save(on: db)
    }
    
    func save(_ accounts: [Account], on db: Database) async throws {
        for account in accounts {
            try await account.save(on: db)
        }
    }
    
    func findAccount(by ID: UUID, on db: Database) async throws -> Account? {
        try await Account.query(on: db)
            .filter(\.$id == ID)
            .first()
    }
    
    func delete(_ account: Account, on db: Database) async throws {
        try await account.delete(on: db)
    }
}
