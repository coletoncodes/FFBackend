//
//  CreateUser.swift
//  
//
//  Created by Coleton Gorecke on 5/13/23.
//

import Fluent
import Vapor

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
