//
//  JWTTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

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
    func generateAccessToken(for user: User) throws -> AccessTokenDTO
    
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
    private let signer: JWTSigner
    
    init() {
        // Create an HMAC with SHA-256 signer using your application's secret key
        // TODO: Inject from environment
        self.signer = JWTSigner.hs256(key: "your-secret-key")
    }
    
    func generateAccessToken(for user: User) throws -> AccessTokenDTO {
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "Missing userID in payload.")
        }
        
        // Create the JWT payload
        let oneHourFromNow = Date().addingTimeInterval(60 * 60)
        let payload = JWTTokenPayload(expiration: .init(value: oneHourFromNow), userID: userID)
        
        // Sign the JWT payload & return
        let token = try signer.sign(payload)
        return AccessTokenDTO(token: token, payload: payload)
    }
    
    func validateAccessToken(_ token: String) throws -> JWTTokenPayload {
        // Verify the JWT signature and decode the payload
        return try signer.verify(token)
    }
}
