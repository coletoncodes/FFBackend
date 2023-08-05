//
//  BankAccountRepository.swift
//  
//
//  Created by Coleton Gorecke on 8/3/23.
//

import Fluent
import Vapor

protocol BankAccountStore {
    func save(_ accounts: [BankAccount], on db: Database) async throws
}

final class BankAccountRepository: BankAccountStore {
    
    func save(_ accounts: [BankAccount], on db: Database) async throws {
        for account in accounts {
            try await account.save(on: db)
        }
    }
}
