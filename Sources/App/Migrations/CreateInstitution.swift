//
//  CreateInstitution.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Fluent
import Vapor

struct CreateInstitution: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Institution.schema)
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("access_token_id", .uuid, .required, .references(PlaidAccessToken.schema, .id, onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(Institution.schema).delete()
    }
}
