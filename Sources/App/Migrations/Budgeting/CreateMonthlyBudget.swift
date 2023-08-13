//
//  CreateMonthlyBudget.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation
import Fluent

struct CreateMonthlyBudget: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(MonthlyBudget.schema)
            .id()
            .field("month", .int16, .required)
            .field("year", .int16, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade, onUpdate: .cascade))
            .unique(on: "month", "year", "user_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(MonthlyBudget.schema).delete()
    }
}
