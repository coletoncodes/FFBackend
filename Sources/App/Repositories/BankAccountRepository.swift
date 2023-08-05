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
            if let existingAccount = try await BankAccount
                .query(on: db)
                .filter(\.$id == account.requireID())
                .first() {
                existingAccount.accountID = account.accountID
                existingAccount.currentBalance = account.currentBalance
                existingAccount.institution = account.institution
                existingAccount.isSyncingTransactions = account.isSyncingTransactions
                existingAccount.name = account.name
                existingAccount.subtype = account.subtype
                try await existingAccount.save(on: db)
            } else {
                try await account.save(on: db)
            }
        }
    }
}
