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
    let userID: UUID?
    let token: String
    let expiresAt: Date?
    
    init(
        userID: UUID?,
        token: String,
        expiresAt: Date?
    ) {
        self.userID = userID
        self.token = token
        self.expiresAt = expiresAt
    }
    
    init(from jwtToken: JWTToken) {
        self.init(
            userID: jwtToken.user.id,
            token: jwtToken.token,
            expiresAt: jwtToken.expiresAt
        )
    }
}

struct JWTTokenPayload: JWTPayload, Authenticatable {
    let expiration: ExpirationClaim
    let userID: User.IDValue
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
