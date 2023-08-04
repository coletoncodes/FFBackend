//
//  CreateInstitution.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Foundation

struct CreateInstitution: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Institution.schema)
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .field("access_token_id", .uuid, .required, .references(PlaidAccessToken.schema, .id, onDelete: .cascade))
            .field("plaid_item_id", .string, .required)
            .unique(on: "plaid_item_id", "user_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Institution.schema).delete()
    }
}
