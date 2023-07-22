//
//  CreateBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import FFAPI
import Fluent

struct CreateBudgetCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(BudgetCategory.schema)
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .field("budget_items", .array(of: .custom(FFBudgetItem.self)))
            .unique(on: .id)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(BudgetCategory.schema).delete()
    }
}
