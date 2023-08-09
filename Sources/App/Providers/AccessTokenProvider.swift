//
//  JWTTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import FFAPI
import Factory
import JWT
import Vapor

/// The protocol outlining the responsibilities for an access token provider.
///
/// A AccessTokenProviding object is responsible for generating and validating JWT tokens.
protocol AccessTokenProviding {
    /// Generates an access token for the provided user.
    ///
    /// This method is responsible for creating a new access token. The token should be
    /// created with the necessary claims and signed with the application's secret key.
    ///
    /// - Parameter user: The User object for which to generate a token.
    /// - Returns: The newly generated JWTToken as a String.
    func generateAccessToken(for user: FFUser) throws -> FFAccessToken
    
    
    /// Sign's an existing access token for a give JWTTokenPayload
    /// - Parameter payload: The token object representing a validated token.
    /// - Returns: The access token object
    func signAccessToken(for payload: JWTTokenPayload) throws -> FFAccessToken
    
    /// Validates a provided Access token.
    ///
    /// This method is responsible for decoding the provided JWT token, verifying its
    /// signature and its claims, and returning a corresponding JWTToken object if
    /// the token is valid.
    ///
    /// - Parameter token: The token string to validate.
    /// - Returns: A JWTTokenPayload object representing the validated token.
    func validateAccessToken(_ token: String) throws -> JWTTokenPayload
}

/// The concrete implementation of the AccessTokenProviding protocol.
///
/// This object utilizes Vapor's JWT library to generate and validate JWT tokens.
final class AccessTokenProvider: AccessTokenProviding {
    // MARK: - Dependencies
    @Injected(\.jwtSigner) private var signer
    
    // MARK: - Interface
    func generateAccessToken(for user: FFUser) throws -> FFAccessToken {
        // Create the JWT payload that expires in one hour.
        guard let oneHourFromNow = Date.oneHourFromNow else {
            throw Abort(.internalServerError, reason: "Failed to configure date for JWT token.")
        }
        
        let payload = JWTTokenPayload(expiration: .init(value: oneHourFromNow), userID: user.id)
        
        // Sign the JWT payload & return
        return try signAccessToken(for: payload)
    }
    
    // Sign the JWT payload
    func signAccessToken(for payload: JWTTokenPayload) throws -> FFAccessToken {
        let token = try signer.sign(payload)
        return FFAccessToken(token: token, payload: payload)
    }
    
    func validateAccessToken(_ token: String) throws -> JWTTokenPayload {
        // Verify the JWT signature and decode the payload
        do {
            return try signer.verify(token)
        } catch {
            throw Abort(.unauthorized, reason: "Access Token is expired or invalid. Please login again.")
        }
    }
}

extension FFAccessToken {
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
