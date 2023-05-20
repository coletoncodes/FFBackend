//
//  RefreshTokenDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Vapor

/// The RefreshToken Data Transfer Object.
///
/// Used to encapsulate a Refresh Token.
/// The refresh token is used to generate new access tokens.
/// It is sent to the server when the client needs a new access token (i.e., when the old one expires).
/// Refresh tokens have a longer lifespan.
/// The server keeps track of refresh tokens and can invalidate them if needed.
struct RefreshTokenDTO: Content {
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
    
    init(from refreshToken: RefreshToken) {
        self.init(
                userID: refreshToken.id,
                token: refreshToken.token,
                expiresAt: refreshToken.expiresAt
            )
    }
}
