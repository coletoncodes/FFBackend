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
            .field("access_token_id", .uuid, .required, .references(PlaidAccessToken.schema, .id))
            .field("item_id", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Institution.schema).delete()
    }
}

struct CreateAccount: AsyncMigration {
    func prepare(on database: Database) async throws  {
        try await database.schema(Account.schema)
            .id()
            .field("account_id", .string, .required)
            .field("name", .string, .required)
            .field("subtype", .string, .required)
            .field("institution_id", .uuid, .required, .references(Institution.schema, .id))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Account.schema).delete()
    }
}
