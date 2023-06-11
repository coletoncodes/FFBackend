//
//  RefreshTokenRepository.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Fluent
import Vapor

protocol RefreshTokenStore {
    func save(_ token: RefreshToken, on db: Database) async throws
    func find(_ token: String, on db: Database) async throws -> RefreshToken?
    func findToken(for user: User, on db: Database) async throws -> RefreshToken?
    func delete(_ token: RefreshToken, on db: Database) async throws
}

final class RefreshTokenRepository: RefreshTokenStore {
    func save(_ token: RefreshToken, on db: Database) async throws {
        try await token.save(on: db)
    }

    func find(_ token: String, on db: Database) async throws -> RefreshToken? {
        try await RefreshToken.query(on: db).filter(\.$token == token).first()
    }
    
    func findToken(for user: User, on db: Database) async throws -> RefreshToken? {
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "The user's ID is nil.")
        }
        
        return try await RefreshToken.query(on: db)
            .filter(\.$user.$id, .equal, userID)
            .first()
    }

    func delete(_ token: RefreshToken, on db: Database) async throws {
        try await token.delete(on: db)
    }
}
