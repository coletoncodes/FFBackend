//
//  CreateTransaction.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Fluent

struct CreateTransaction: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Transaction.schema)
            .id()
            .field("bank_account_id", .uuid, .required,
                   .references(BankAccount.schema, .id, onDelete: .cascade))
            .field("name", .string, .required)
            .field("date", .datetime, .required)
            .field("amount", .double, .required)
            .unique(on: .id)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(Transaction.schema).delete()
    }
}
