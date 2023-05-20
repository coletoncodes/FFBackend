//
//  RefreshTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Vapor

protocol RefreshTokenProviding {
    func generateToken(for user: User) throws -> RefreshTokenDTO
    func validateToken(_ token: String) throws -> RefreshTokenDTO
}

final class RefreshTokenProvider: RefreshTokenProviding {
    func generateToken(for user: User) throws -> RefreshTokenDTO {
        // Implement the logic for generating a RefreshToken here.
        RefreshTokenDTO(userID: nil, token: "", expiresAt: nil)
    }
    
    func validateToken(_ token: String) throws -> RefreshTokenDTO {
        // Implement the logic for validating a RefreshToken here.
        RefreshTokenDTO(userID: nil, token: "", expiresAt: nil)
    }
}
