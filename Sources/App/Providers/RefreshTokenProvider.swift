//
//  RefreshTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Foundation
import Vapor
import FluentKit

protocol RefreshTokenProviding {
    func generateRefreshToken(for user: User, on req: Request) async throws -> RefreshTokenDTO
    func validateRefreshToken(_ token: String, on req: Request) async throws -> RefreshTokenDTO
    func invalidate(_ token: String, on req: Request) async throws
}

final class RefreshTokenProvider: RefreshTokenProviding {
    // MARK: - Dependencies
    private var tokenStore: RefreshTokenStore
    
    // MARK: - Initializer
    init(
        tokenStore: RefreshTokenStore = RefreshTokenRepository()
    ) {
        self.tokenStore = tokenStore
    }
    
    // MARK: - Interface
    func generateRefreshToken(for user: User, on req: Request) async throws -> RefreshTokenDTO {
        guard let userID = user.id else {
            throw Abort(.unauthorized, reason: "UserID was nil.")
        }
        
        // Remove any existing tokens
        try await removeExistingTokens(for: user, on: req)
        
        // Create a new RefreshToken that expires in 30 days.
        let refreshToken = RefreshToken(
            userID: userID,
            token: UUID().uuidString,
            expiresAt: Date.thirtyDaysFromNow
        )
        
        // Save it to the database
        try await tokenStore.save(refreshToken, on: req.db)
        
        // Return a DTO
        return RefreshTokenDTO(userID: refreshToken.$user.id, token: refreshToken.token, expiresAt: refreshToken.expiresAt)
    }
    
    func validateRefreshToken(_ token: String, on req: Request) async throws -> RefreshTokenDTO {
        // Find the token in the database
        guard let foundRefreshToken = try await tokenStore.find(token, on: req.db) else {
            throw Abort(.unauthorized, reason: "Unable to find matching token in database.")
        }
        
        // Get the user associated with the token
        let user = try await foundRefreshToken.$user.get(on: req.db)
        
        // Invalidate the old token.
        try await invalidate(foundRefreshToken.token, on: req)
        
        // Return the new token
        return try await generateRefreshToken(for: user, on: req)
    }
    
    func invalidate(_ token: String, on req: Request) async throws {
        // Find the token in the database
        guard let foundRefreshToken = try await tokenStore.find(token, on: req.db) else {
            throw Abort(.unauthorized, reason: "Unable to find matching token in database.")
        }
        
        // Delete the token
        try await tokenStore.delete(foundRefreshToken, on: req.db)
    }
    
    // MARK: - Helpers
    func removeExistingTokens(for user: User, on req: Request) async throws {
        guard let userID = user.id else {
            throw Abort(.unauthorized, reason: "Unable to find matching tokens for user.")
        }
        
        // Get Tokens
        let tokens = try await RefreshToken
            .query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
        
        // Delete each one
        for refreshToken in tokens {
            try await self.invalidate(refreshToken.token, on: req)
        }
    }
}
