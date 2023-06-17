//
//  CreateInstitutionAccount.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Fluent
import Vapor

struct CreateInstitutionAccount: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database
            .schema(InstitutionAccount.schema)
            .id()
            .field("institution_id", .uuid, .required, .references(Institution.schema, .id, onDelete: .cascade))
            .field("account_id", .uuid, .required, .references(Account.schema, .id, onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(InstitutionAccount.schema).delete()
    }
}
