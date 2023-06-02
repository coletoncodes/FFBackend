//
//  PlaidLinkTokenRepository.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Fluent
import Vapor

protocol PlaidLinkTokenStore {
    func save(_ token: PlaidLinkToken, on db: Database) async throws
    func findTokenForUser(_ userId: UUID, on db: Database) async throws -> PlaidLinkToken?
    func delete(_ token: PlaidLinkToken, on db: Database) async throws
}

struct PlaidLinkTokenRepository: PlaidLinkTokenStore {
    func save(_ token: PlaidLinkToken, on db: Database) async throws {
        try await token.save(on: db)
    }
    
    func findTokenForUser(_ userId: UUID, on db: Database) async throws -> PlaidLinkToken? {
        try await PlaidLinkToken.query(on: db)
            .filter(\.$user.$id == userId)
            .first()
    }
    
    func delete(_ token: PlaidLinkToken, on db: Database) async throws {
        try await token.delete(on: db)
    }
}
