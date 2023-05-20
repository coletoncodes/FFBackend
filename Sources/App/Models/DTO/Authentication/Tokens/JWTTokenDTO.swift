//
//  JWTTokenDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import JWT
import Vapor

/// The JWTToken Data Transfer Object.
///
/// Used to encapsulate a JWT Token.
/// The JWT token is an access token that is used to secure API endpoints.
/// It is included in the HTTP header for every API request.
/// The server validates this token and if it's valid, processes the request.
/// Access tokens have a short lifespan for security reasons.
/// If a token is stolen, it's only valid for a short time.
struct JWTTokenDTO: Content {
    let token: String
    let expiresAt: Date?
    
    init(token: String, expiresAt: Date?) {
        self.token = token
        self.expiresAt = expiresAt
    }
    
    init(token: String, payload: JWTTokenPayload) {
        self.init(token: token, expiresAt: payload.expiration.value)
    }
}

struct JWTTokenPayload: JWTPayload, Authenticatable {
    let expiration: ExpirationClaim
    let userID: User.IDValue
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
