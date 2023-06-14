//
//  CreateAccount.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Fluent
import Vapor

struct CreateAccount: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(Account.schema)
            .id()
            .field("account_id", .string, .required)
            .field("name", .string, .required)
            .field("subtype", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(Account.schema).delete()
    }
}
