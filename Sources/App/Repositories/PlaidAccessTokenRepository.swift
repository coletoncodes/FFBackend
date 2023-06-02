//
//  PlaidAccessTokenRepository.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Fluent
import Vapor

protocol PlaidAccessTokenStore {
    func save(_ token: PlaidAccessToken, on db: Database) async throws
    func findTokenForUser(_ userId: UUID, on db: Database) async throws -> PlaidAccessToken?
    func delete(_ token: PlaidAccessToken, on db: Database) async throws
}

final class PlaidAccessTokenRepository: PlaidAccessTokenStore {
    func save(_ token: PlaidAccessToken, on db: Database) async throws {
        try await token.save(on: db)
    }
    
    func findTokenForUser(_ userId: UUID, on db: Database) async throws -> PlaidAccessToken? {
        try await PlaidAccessToken.query(on: db)
            .filter(\.$user.$id == userId)
            .first()
    }
    
    func delete(_ token: PlaidAccessToken, on db: Database) async throws {
        try await token.delete(on: db)
    }
}
