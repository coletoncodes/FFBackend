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
                   .references(BudgetItem.schema, .id, onDelete: .cascade))
            .field("name", .string, .required)
            .field("planned", .double, .required)
            .field("due_date", .date)
            .unique(on: .id)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database
            .schema(BudgetItem.schema)
            .delete()
    }
}

