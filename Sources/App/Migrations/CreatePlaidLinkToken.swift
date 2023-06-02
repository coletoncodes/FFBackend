//
//  CreatePlaidLinkToken.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Fluent

struct CreatePlaidLinkToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(PlaidLinkToken.schema)
            .id()
            .field("link_token", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .unique(on: "link_token")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(PlaidLinkToken.schema).delete()
    }
}
