//
//  RefreshTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Foundation
import Vapor

protocol RefreshTokenProviding {
    func generateToken(for user: User, on req: Request) async throws -> RefreshTokenDTO
    func validateToken(_ token: String, on req: Request) async throws -> RefreshTokenDTO
}

final class RefreshTokenProvider: RefreshTokenProviding {
    // TODO: Move to DI
    private let tokenStore: RefreshTokenStore = RefreshTokenRepository()
    
    func generateToken(for user: User, on req: Request) async throws -> RefreshTokenDTO {
        guard let userID = user.id else {
            throw Abort(.unauthorized, reason: "UserID was nil.")
        }
        
        // Create a new RefreshToken that expires in 30 days.
        let refreshToken = RefreshToken(
            userID: userID,
            token: UUID().uuidString,
            expiresAt: Date().addingTimeInterval(3600 * 24 * 30)
        )
        
        // Save it to the database
        try await tokenStore.save(refreshToken, on: req.db)
        
        // Return a DTO
        return RefreshTokenDTO(userID: refreshToken.$user.id, token: refreshToken.token, expiresAt: refreshToken.expiresAt)
    }
    
    func validateToken(_ token: String, on req: Request) async throws -> RefreshTokenDTO {
        // Find the token in the database
        guard let foundToken = try await tokenStore.find(token, on: req.db) else {
            throw Abort(.unauthorized)
        }
        
        // If the token has expired, delete it
        if let expiresAt = foundToken.expiresAt, expiresAt < Date() {
            try await tokenStore.delete(foundToken, on: req.db)
            
            // Generate a new refresh token for the user
            return try await generateToken(for: foundToken.user, on: req)
        }
        
        // If the token has not expired, return the existing one
        return RefreshTokenDTO(userID: foundToken.$user.id, token: foundToken.token, expiresAt: foundToken.expiresAt)
    }
}
