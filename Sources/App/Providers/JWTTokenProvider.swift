//
//  JWTTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import JWT
import Vapor

/// The protocol outlining the responsibilities for a JWT token provider.
///
/// A JWTTokenProviding object is responsible for generating and validating JWT tokens.
protocol JWTTokenProviding {
    /// Generates a JWT token for the provided user.
    ///
    /// This method is responsible for creating a new JWT token. The token should be
    /// created with the necessary claims and signed with the application's secret key.
    ///
    /// - Parameter user: The User object for which to generate a token.
    /// - Returns: The newly generated JWTToken as a String.
    func generateToken(for user: User) throws -> JWTTokenDTO
    
    /// Validates a provided JWT token.
    ///
    /// This method is responsible for decoding the provided JWT token, verifying its
    /// signature and its claims, and returning a corresponding JWTToken object if
    /// the token is valid.
    ///
    /// - Parameter token: The token string to validate.
    /// - Returns: A JWTTokenPayload object representing the validated token.
    func validateToken(_ token: String) throws -> JWTTokenPayload
}

/// The concrete implementation of the JWTTokenProviding protocol.
///
/// This object utilizes Vapor's JWT library to generate and validate JWT tokens.
final class JWTTokenProvider: JWTTokenProviding {
    private let signer: JWTSigner
    
    init() {
        // Create an HMAC with SHA-256 signer using your application's secret key
        // TODO: Inject from environment
        self.signer = JWTSigner.hs256(key: "your-secret-key")
    }
    
    func generateToken(for user: User) throws -> JWTTokenDTO {
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "Missing userID in payload.")
        }
        
        // Create the JWT payload
        let payload = JWTTokenPayload(expiration: .init(value: .distantFuture), userID: userID)
        
        // Sign the JWT payload & return
        let token = try signer.sign(payload)
        return JWTTokenDTO(token: token, payload: payload)
    }
    
    func validateToken(_ token: String) throws -> JWTTokenPayload {
        // Verify the JWT signature and decode the payload
        return try signer.verify(token)
    }
}

