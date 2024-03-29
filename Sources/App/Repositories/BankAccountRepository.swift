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
    func getBankAccount(matching id: BankAccount.IDValue, on db: Database) async throws -> BankAccount?
}

final class BankAccountRepository: BankAccountStore {
    
    func save(_ accounts: [BankAccount], on db: Database) async throws {
        for account in accounts {
            if let existingAccount = try await BankAccount
                .query(on: db)
                .filter(\.$accountID == account.accountID)
                .first() {
                existingAccount.currentBalance = account.currentBalance
                existingAccount.isSyncingTransactions = account.isSyncingTransactions
                existingAccount.name = account.name
                existingAccount.subtype = account.subtype
                existingAccount.currentBalance = account.currentBalance
                try await existingAccount.save(on: db)
            } else {
                try await account.save(on: db)
            }
        }
    }
    
    func getBankAccount(matching id: BankAccount.IDValue, on db: Database) async throws -> BankAccount? {
        return try await BankAccount
            .query(on: db)
            .filter(\.$id == id)
            .first()
    }
}
