//
//  RefreshTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Vapor

protocol RefreshTokenProviding {
    func generateToken(for user: User) throws -> RefreshToken
    func validateToken(_ token: String) throws -> RefreshToken
}

final class RefreshTokenProvider: RefreshTokenProviding {
    func generateToken(for user: User) throws -> RefreshToken {
        // Implement the logic for generating a RefreshToken here.
        RefreshToken()
    }
    
    func validateToken(_ token: String) throws -> RefreshToken {
        // Implement the logic for validating a RefreshToken here.
        RefreshToken()
    }
}
