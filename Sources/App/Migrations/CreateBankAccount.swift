//
//  CreateBankAccount.swift
//  
//
//  Created by Coleton Gorecke on 8/3/23.
//

import Fluent
import Foundation

struct CreateBankAccount: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(BankAccount.schema)
            .id()
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .field("institution_id", .uuid, .required, .references(Institution.schema, .id, onDelete: .cascade))
            .field("account_id", .string, .required)
            .field("name", .string, .required)
            .field("subtype", .string, .required)
            .field("is_syncing_transactions", .bool, .required)
            .field("current_balance", .double, .required)
            .unique(on: "account_id", "user_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(BankAccount.schema).delete()
    }
}
