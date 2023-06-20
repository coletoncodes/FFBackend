//
//  CreateAccount.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Vapor

struct CreateAccount: AsyncMigration {
    func prepare(on database: Database) async throws  {
        try await database.schema(Account.schema)
            .id()
            .field("account_id", .string, .required)
            .field("name", .string, .required)
            .field("subtype", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .field("institution_id", .uuid, .required, .references(Institution.schema, .id, onDelete: .cascade))
            .unique(on: "account_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Account.schema).delete()
    }
}
