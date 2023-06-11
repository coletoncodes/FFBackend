//
//  AccessTokenDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import JWT
import Vapor

/// The AccessToken Data Transfer Object.
///
/// Used to encapsulate a JWT.
/// The JWT token is an access token that is used to secure API endpoints.
/// It is included in the HTTP header for every API request.
/// The server validates this token and if it's valid, processes the request.
/// Access tokens have a short lifespan for security reasons.
/// If a token is stolen, it's only valid for a short time.
struct AccessTokenDTO: Content {
    let token: String
    let userID: User.IDValue
    
    init(
        token: String,
        userID: User.IDValue
    ) {
        self.token = token
        self.userID = userID
    }
    
    init(token: String, payload: JWTTokenPayload) {
        self.init(
            token: token,
            userID: payload.userID
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
