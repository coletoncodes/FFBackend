//
//  CreatePlaidAccessToken.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Fluent

struct CreatePlaidAccessToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(PlaidAccessToken.schema)
            .id()
            .field("access_token", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .unique(on: "access_token", "user_id")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(PlaidAccessToken.schema).delete()
    }
}
