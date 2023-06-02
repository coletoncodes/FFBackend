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
    func delete(_ token: RefreshToken, on db: Database) async throws
}

struct RefreshTokenRepository: RefreshTokenStore {
    func save(_ token: RefreshToken, on db: Database) async throws {
        try await token.save(on: db)
    }

    func find(_ token: String, on db: Database) async throws -> RefreshToken? {
        try await RefreshToken.query(on: db).filter(\.$token == token).first()
    }

    func delete(_ token: RefreshToken, on db: Database) async throws {
        try await token.delete(on: db)
    }
}
