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
    func delete(_ token: PlaidAccessToken, on db: Database) async throws
    func findTokenMatching(_ id: PlaidAccessToken.IDValue, on db: Database) async throws -> PlaidAccessToken
}

final class PlaidAccessTokenRepository: PlaidAccessTokenStore {
    func save(_ token: PlaidAccessToken, on db: Database) async throws {
        try await token.save(on: db)
    }
    
    func delete(_ token: PlaidAccessToken, on db: Database) async throws {
        try await token.delete(on: db)
    }
    
    func findTokenMatching(_ id: PlaidAccessToken.IDValue, on db: Database) async throws -> PlaidAccessToken {
        guard let foundToken = try await PlaidAccessToken
            .query(on: db)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.internalServerError, reason: "No matching PlaidAccessToken with id: \(id) exists.")
        }
        return foundToken
    }
}
