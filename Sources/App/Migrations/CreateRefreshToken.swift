//
//  CreateRefreshToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Fluent
import Vapor

struct CreateRefreshToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database
            .schema(RefreshToken.schema)
            .id()
            .field("token", .string, .required)
            .field("user_id", .uuid, .required, .references(User.schema, .id))
            .field("created_at", .datetime)
            .field("expires_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database
            .schema(RefreshToken.schema)
            .delete()
    }
}
