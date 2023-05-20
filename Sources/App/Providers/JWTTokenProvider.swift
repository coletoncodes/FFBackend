//
//  JWTTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Vapor

protocol JWTTokenProviding {
    func generateToken(for user: User) throws -> JWTToken
    func validateToken(_ token: String) throws -> JWTToken
}

final class JWTTokenProvider: JWTTokenProviding {
    func generateToken(for user: User) throws -> JWTToken {
        // Implement the logic for generating a JWTToken here.
        // This will involve creating a JWT, signing it and returning a JWTToken entity.
        JWTToken()
    }
    
    func validateToken(_ token: String) throws -> JWTToken {
        // Implement the logic for validating a JWT here.
        // This will involve decoding the JWT, verifying the signature and returning a JWTToken entity.
        JWTToken()
    }
}
