//
//  CreateBudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/24/23.
//

import Foundation
import Fluent

struct CreateBudgetItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(BudgetItem.schema)
            .id()
            .field("budget_category_id", .uuid, .required,
                   .references(BudgetCategory.schema, .id, onDelete: .cascade))
            .field("name", .string, .required)
            .field("planned", .double, .required)
            .field("due_date", .date)
            .field("category_type", .string, .required)
            .unique(on: .id)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database
            .schema(BudgetItem.schema)
            .delete()
    }
}

