//
//  CreateTransaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import Fluent

struct CreateTransaction: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Transaction.schema)
            .id()
            .field("name", .string, .required)
            .field("budget_item_id", .uuid, .required,
                   .references(BudgetItem.schema, .id, onDelete: .cascade))
            .field("amount", .double, .required)
            .field("date_string", .string, .required)
            .field("transaction_type", .string, .required)
            .unique(on: .id)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Transaction.schema).delete()
    }
}
