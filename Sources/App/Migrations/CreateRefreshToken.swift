//
//  CreateRefreshToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Fluent

struct CreateRefreshToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(RefreshToken.schema)
            .id()
            .field("token", .string, .required)
            .field("user_id", .uuid, .required,
                   .references(User.schema, .id, onDelete: .cascade))
            .field("expires_at", .datetime, .required)
            .unique(on: "token")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(RefreshToken.schema).delete()
    }
}
