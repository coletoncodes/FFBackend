//
//  DeletePlaidLinkToken.swift
//  
//
//  Created by Coleton Gorecke on 6/2/23.
//

import Fluent

struct DeletePlaidLinkToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(PlaidLinkToken.schema)
            .delete()
    }

    func revert(on database: Database) async throws  {
        try await database.schema(PlaidLinkToken.schema)
            .id()
            .field("link_token", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .unique(on: "link_token")
            .create()
    }
}
