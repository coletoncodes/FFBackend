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
 - The server validates the refresh token and if it's valid, generates a new access token and a new refresh token and sends them back to the client.
 - The client replaces the old access token with the new one and continues making API requests.
 */
struct AuthenticationController: RouteCollection {
    // MARK: - Dependencies
    // TODO: Move to DI
    private let accessTokenProvider: AccessTokenProviding = AccessTokenProvider()
    private let refreshTokenProvider: RefreshTokenProviding = RefreshTokenProvider()
    private let userStore: UserStore = UserRepository()
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            // auth/register
            auth.post("register", use: register)
            // auth/login
            auth.post("login", use: login)
            // auth/refresh
            auth.post("refresh", use: refreshSession)
            // auth/logout
            auth.post("logout", use: logout)
        }
    }
}

// MARK: - Requests
private extension AuthenticationController {
    /// Register's a new user, generates JWT and refresh tokens, and saves them to the database.
    ///
    /// This endpoint requires a `RegisterRequest` object with valid user details. It validates the
    /// request content, creates a new User record, and generates JWT and refresh tokens associated
    /// with the user.
    ///
    /// Finally, it responds with a `SessionResponse` containing the user details and
    /// the newly generated tokens.
    ///
    /// - Parameters:
    ///     - req: The request received from the client, containing the `RegisterRequest` object.
    /// - Returns: A `SessionResponse` object containing the user details and associated tokens.
    func register(_ req: Request) async throws -> SessionResponse {
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
        
        // Return the session for the user
        return try await createSession(for: user, on: req)
    }
    
    /// Authenticates an existing user, generates new JWT and refresh tokens, and returns them in the response.
    ///
    /// This endpoint requires a `LoginRequest` object with valid user details. It validates the
    /// request content, verifies the user's password, and generates new JWT and refresh tokens
    /// associated with the user.
    ///
    /// Finally, it responds with a `SessionResponse` containing the user
    /// details and the newly generated tokens.
    ///
    /// - Parameters:
    ///     - req: The request received from the client, containing the `LoginRequest` object.
    /// - Returns: A `SessionResponse` object containing the user details and associated tokens.
    func login(_ req: Request) async throws -> SessionResponse {
        do {
            try LoginRequest.validate(content: req)
        } catch {
            let logStr = "Invalid request data: \(error)"
            throw Abort(.badRequest, reason: logStr)
        }
        
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await userStore.find(byEmail: loginRequest.email, on: req.db) else {
            throw Abort(.unauthorized, reason: "Failed to find user with a matching email.")
        }
        
        do {
            guard try Bcrypt.verify(loginRequest.password, created: user.passwordHash) else {
                throw Abort(.unauthorized, reason: "Password is invalid.")
            }
            
            // Create the session
            return try await createSession(for: user, on: req)
        } catch {
            let logStr = "Password verification failed: \(error)"
            throw Abort(.unauthorized, reason: logStr)
        }
    }
    
    /// This function is responsible for refreshing the user's access token.
    ///
    /// It takes the refresh token from the request's authorization header, validates it,
    /// and then generates a new access token for the associated user.
    /// This function is typically used when a client's access token has expired, but their refresh token is still valid.
    ///
    /// - Parameter req: The incoming `Request`, which should contain the refresh token in the authorization header.
    ///
    /// - Throws: An `Abort` error with a `.unauthorized` status and a relevant message if:
    ///     - The refresh token is not found in the request's authorization header.
    ///     - The refresh token is not valid.
    ///     - The user associated with the refresh token cannot be found.
    /// - Returns: `SessionResponse`
    func refreshSession(_ req: Request) async throws -> SessionResponse {
        // Extract the refresh token from the request
        guard let token = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No refresh token found in request.")
        }
        
        // Validate the refresh token
        let refreshTokenDTO: RefreshTokenDTO
        do {
            refreshTokenDTO = try await refreshTokenProvider.validateRefreshToken(token, on: req)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid refresh token.")
        }
        
        guard
            let userID = refreshTokenDTO.userID,
            let user = try await userStore.find(byID: userID, on: req.db)
        else {
            throw Abort(.internalServerError, reason: "The user doesn't exist.")
        }
        
        // Create the session
        return try await createSession(for: user, on: req)
    }
    
    func logout(_ req: Request) async throws -> HTTPStatus {
        // Extract the refresh token from the request
        guard let token = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No refresh token found in request.")
        }
        
        // Invalidate the refreshToken. Removing access completely.
        try await refreshTokenProvider.invalidate(token, on: req)
        
        // Return success
        return .ok
    }
}

// MARK: - Helpers
extension AuthenticationController {
    func createSession(for user: User, on req: Request) async throws -> SessionResponse {
        // Generate tokens
        let accessTokenDTO = try accessTokenProvider.generateAccessToken(for: user)
        let refreshTokenDTO = try await refreshTokenProvider.generateRefreshToken(for: user, on: req)
        let userDTO = UserDTO(from: user)
        
        // Return session
        let session = SessionDTO(accessToken: accessTokenDTO, refreshToken: refreshTokenDTO)
        return SessionResponse(user: userDTO, session: session)
    }
}
