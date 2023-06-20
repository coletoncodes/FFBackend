//
//  JWTTokenProvider.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

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
    // MARK: - Dependencies
    @Injected(\.jwtSigner) private var signer
    
    // MARK: - Interface
    func generateAccessToken(for user: User) throws -> AccessTokenDTO {
        guard let userID = user.id else {
            throw Abort(.internalServerError, reason: "Missing userID in payload.")
        }
        
        // Create the JWT payload that expires in one hour.
        guard let oneHourFromNow = Date.oneHourFromNow else {
            throw Abort(.internalServerError, reason: "Failed to configure date for JWT token.")
        }
        
        let payload = JWTTokenPayload(expiration: .init(value: oneHourFromNow), userID: userID)
        
        // Sign the JWT payload & return
        let token = try signer.sign(payload)
        return AccessTokenDTO(token: token, payload: payload)
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
