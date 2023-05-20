//
//  AuthenticationCollection.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Fluent
import Vapor

/*
 - The user logs in with their username and password.
 - The server validates the username and password, generates an access token and a refresh token, and sends them both back to the client.
 - The client stores the refresh token securely and starts using the access token for API requests.
 - When the access token expires, the client sends the refresh token to the server and asks for a new access token.
 - The server validates the refresh token and if it's valid, generates a new access token (and possibly a new refresh token) and sends them back to the client.
 - The client replaces the old access token with the new one and continues making API requests.
 - If the user logs out, the server invalidates the refresh token.
 */
struct AuthenticationController: RouteCollection {
    // MARK: - Dependencies
    // TODO: Move to DI
    private let accessTokenProvider: AccessTokenProviding = AccessTokenProvider()
    private let refreshTokenProvider: RefreshTokenProviding = RefreshTokenProvider()
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            auth.post("login", use: login)
        }
    }
}

// MARK: - Requests
private extension AuthenticationController {
    /// Register's a new user, generates JWT and refresh tokens, and saves them to the database.
    ///
    /// This endpoint requires a `RegisterRequest` object with valid user details. It validates the
    /// request content, creates a new User record, and generates JWT and refresh tokens associated
    /// with the user. Finally, it responds with a `LoginResponse` containing the user details and
    /// the newly generated tokens.
    ///
    /// - Parameters:
    ///     - req: The request received from the client, containing the `RegisterRequest` object.
    /// - Returns: A `LoginResponse` object containing the user details and associated tokens.
    func register(_ req: Request) async throws -> LoginResponse {
        do {
            try RegisterRequest.validate(content: req)
        } catch {
            let logStr = "Invalid request data: \(error)"
            throw Abort(.badRequest, reason: logStr)
        }
        
        let registerRequest = try req.content.decode(RegisterRequest.self)
        
        guard registerRequest.password == registerRequest.confirmPassword else {
            let logStr = "Provided passwords do not match."
            throw Abort(.badRequest, reason: logStr)
        }
        
        let user = try User(from: registerRequest)
        try await user.save(on: req.db)
        
        // Generate tokens
        let accessTokenDTO = try accessTokenProvider.generateAccessToken(for: user)
        let refreshTokenDTO = try refreshTokenProvider.generateToken(for: user)
        let userDTO = UserDTO(from: user)
        
        return LoginResponse(user: userDTO, accessToken: accessTokenDTO, refreshToken: refreshTokenDTO)
    }
    
    /// Authenticates an existing user, generates new JWT and refresh tokens, and returns them in the response.
    ///
    /// This endpoint requires a `LoginRequest` object with valid user details. It validates the
    /// request content, verifies the user's password, and generates new JWT and refresh tokens
    /// associated with the user. Finally, it responds with a `LoginResponse` containing the user
    /// details and the newly generated tokens.
    ///
    /// - Parameters:
    ///     - req: The request received from the client, containing the `LoginRequest` object.
    /// - Returns: A `LoginResponse` object containing the user details and associated tokens.
    func login(_ req: Request) async throws -> LoginResponse {
        do {
            try LoginRequest.validate(content: req)
        } catch {
            let logStr = "Invalid request data: \(error)"
            throw Abort(.badRequest, reason: logStr)
        }
        
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User
            .query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Failed to find user with a matching email.")
        }
        
        do {
            guard try Bcrypt.verify(loginRequest.password, created: user.passwordHash) else {
                throw Abort(.unauthorized, reason: "Password is invalid.")
            }
            
            // Generate tokens
            let accessTokenDTO = try accessTokenProvider.generateAccessToken(for: user)
            let refreshTokenDTO = try refreshTokenProvider.generateToken(for: user)
            let userDTO = UserDTO(from: user)
            
            return LoginResponse(user: userDTO, accessToken: accessTokenDTO, refreshToken: refreshTokenDTO)
        } catch {
            let logStr = "Password verification failed: \(error)"
            throw Abort(.internalServerError, reason: logStr)
        }
    }
}
