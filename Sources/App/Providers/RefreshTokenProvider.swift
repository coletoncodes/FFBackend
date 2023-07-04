//
//  RefreshTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import FFAPI
import Factory
import Foundation
import Vapor
import FluentKit

protocol RefreshTokenProviding {
    func generateRefreshToken(for ffUser: FFUser, on req: Request) async throws -> FFRefreshToken
    func validateRefreshToken(_ token: String, on req: Request) async throws -> FFRefreshToken
    func invalidate(_ token: String, on req: Request) async throws
    func existingToken(for ffUser: FFUser, on req: Request) async throws -> FFRefreshToken?
}

final class RefreshTokenProvider: RefreshTokenProviding {
    // MARK: - Dependencies
    @Injected(\.refreshTokenStore) private var tokenStore
    
    // MARK: - Interface
    func generateRefreshToken(for ffUser: FFUser, on req: Request) async throws -> FFRefreshToken {
        guard let userID = ffUser.id else {
            throw Abort(.unauthorized, reason: "UserID was nil.")
        }
        
        // Remove any existing tokens
        try await removeExistingTokens(for: ffUser, on: req)
        
        // Create a new RefreshToken that expires in 30 days.
        let refreshToken = RefreshToken(
            userID: userID,
            token: UUID().uuidString,
            expiresAt: Date.thirtyDaysFromNow
        )
        
        // Save it to the database
        try await tokenStore.save(refreshToken, on: req.db)
        
        // Return a DTO
        return FFRefreshToken(userID: refreshToken.$user.id, token: refreshToken.token)
    }
    
    func validateRefreshToken(_ token: String, on req: Request) async throws -> FFRefreshToken {
        // Find the token in the database
        guard let foundRefreshToken = try await tokenStore.find(token, on: req.db) else {
            throw Abort(.unauthorized, reason: "Unable to find matching token in database.")
        }
        
        // Get the user associated with the token
        let user = try await foundRefreshToken.$user.get(on: req.db)
        
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "Cannot validate token for user, id is nil.")
        }
        
        return FFRefreshToken(userID: userID, token: foundRefreshToken.token)
    }
    
    func invalidate(_ token: String, on req: Request) async throws {
        // Find the token in the database
        guard let foundRefreshToken = try await tokenStore.find(token, on: req.db) else {
            throw Abort(.unauthorized, reason: "Unable to find matching token in database.")
        }
        
        // Delete the token
        try await tokenStore.delete(foundRefreshToken, on: req.db)
    }
    
    func existingToken(for ffUser: FFUser, on req: Request) async throws -> FFRefreshToken? {
        let user = User(from: ffUser)
        guard let existingToken = try await tokenStore.findToken(for: user, on: req.db) else {
            throw Abort(.unauthorized, reason: "Unable to find matching token in database.")
        }
        
        return FFRefreshToken(from: existingToken)
    }
    
    // MARK: - Helpers
    func removeExistingTokens(for ffUser: FFUser, on req: Request) async throws {
        guard let userID = ffUser.id else {
            throw Abort(.unauthorized, reason: "Unable to find matching tokens for user.")
        }
        
        // Get Tokens
        let tokens = try await RefreshToken
            .query(on: req.db)
            .filter(\.$user.$id == userID)
            .all()
        
        guard !tokens.isEmpty else { return }
        
        // Delete each one
        for refreshToken in tokens {
            try await self.invalidate(refreshToken.token, on: req)
        }
    }
}
