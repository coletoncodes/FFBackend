//
//  AuthenticationCollection.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import FFAPI
import Factory
import Fluent
import Vapor

struct AuthenticationController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.accessTokenProvider) private var accessTokenProvider
    @Injected(\.refreshTokenProvider) private var refreshTokenProvider
    @Injected(\.userProvider) private var userProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            // auth/register
            auth.post("register", use: register)
            // auth/login
            auth.post("login", use: login)
            // auth/logout
            auth.post("logout", ":userID", use: logout)
            // auth/load-session
            auth.post("load-session", use: loadSession)
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
    /// - Parameters:
    ///     - req: The request received from the client, containing the `RegisterRequest` object.
    /// - Returns: A `SessionResponse` object containing the user details and associated tokens.
    func register(_ req: Request) async throws -> FFSessionResponse {
        do {
            try FFRegisterRequest.validate(content: req)
            let registerRequest = try req.content.decode(FFRegisterRequest.self)
            
            guard registerRequest.password == registerRequest.confirmPassword else {
                throw Abort(.badRequest, reason: "Provided passwords do not match.")
            }
            
            let user = try User(from: registerRequest)
            let ffUser = FFUser(from: user)
            try await userProvider.save(ffUser: ffUser, from: req)
            
            // Return the session for the user
            return try await createSession(for: ffUser, on: req)
        } catch {
            req.logger.report(error: String(reflecting: error))
            throw Abort(.badRequest, reason: "Invalid request data", error: error)
        }
    }
    
    /// Authenticates an existing user, generates new JWT and refresh tokens, and returns them in the response.
    ///
    /// This endpoint requires a `LoginRequest` object with valid user details. It validates the
    /// request content, verifies the user's password, and generates new JWT and refresh tokens
    /// associated with the user.
    ///
    /// - Parameters:
    ///     - req: The request received from the client, containing the `LoginRequest` object.
    /// - Returns: A `SessionResponse` object containing the user details and associated tokens.
    func login(_ req: Request) async throws -> FFSessionResponse {
        do {
            try FFLoginRequest.validate(content: req)
        } catch {
            throw Abort(.badRequest, reason: "Invalid request data", error: error)
        }
        
        let loginRequest = try req.content.decode(FFLoginRequest.self)
        
        guard let user = try await userProvider.findBy(email: loginRequest.email, from: req) else {
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
    
    /// Log's the user out and deletes the user's latest RefreshToken from the Database.
    /// - Parameter req: The incoming `Request`, which should contain the refresh token in the authorization header.
    /// - Returns: .ok if successfully deleted the token.
    func logout(_ req: Request) async throws -> HTTPStatus {
        // Verify userID is provided in request.
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing User ID in request.")
        }
        
        // Get the user for the userID
        guard let userDTO = try await userProvider.findBy(id: userID, from: req) else {
            throw Abort(.notFound, reason: "No User exists for the given id: \(userID)")
        }
        
        guard let refreshToken = try await refreshTokenProvider.existingToken(for: userDTO, database: req.db) else {
            throw Abort(.unauthorized, reason: "No refresh token's exist for the given user.")
        }
        
        // Invalidate the refreshToken. Removing access completely.
        try await refreshTokenProvider.invalidate(refreshToken.token, database: req.db)
        
        // Return success
        return .ok
    }
    
    /// Load's the session for the authenticated user.
    /// - Parameter req: The incoming `Request`, which
    /// should contain the refresh & access token in the authorization header.
    /// - Returns: The newly created session for the user.
    func loadSession(_ req: Request) async throws -> FFSessionResponse {
        // Extract the tokens from the request
        guard let accessToken = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Missing access token in header")
        }
        
        guard let refreshToken = req.headers["x-refresh-token"].first else {
            throw Abort(.unauthorized, reason: "Missing refresh token in header")
        }
        
        // Attempt to validate the access token and get its payload
        var jwtPayload: JWTTokenPayload?
        do {
            jwtPayload = try accessTokenProvider.validateAccessToken(accessToken)
        } catch {
            // Access token is invalid or expired.
            // This is okay as long as refresh token is valid.
            req.logger.debug("Access Token is invalid or expired, checking if refresh token is Valid.")
        }
        
        // Validate the refresh token
        var ffRefreshToken: FFRefreshToken?
        do {
            ffRefreshToken = try await refreshTokenProvider.validateRefreshToken(refreshToken, database: req.db)
        } catch {
            throw Abort(.unauthorized, reason: "Refresh token is expired. Please login again.")
        }
        
        guard let jwtPayload = jwtPayload else {
            throw Abort(.internalServerError, reason: "Access token is expired. Please login again.")
        }
        
        guard let ffRefreshToken = ffRefreshToken else {
            throw Abort(.internalServerError, reason: "Refresh token is expired. Please login again.")
        }
        
        // Check if the refresh token corresponds to the same user as the access token
        guard let ffUser = try await userProvider.findBy(id: jwtPayload.userID, from: req) else {
            throw Abort(.internalServerError, reason: "No user exists for this id.")
        }
        
        let ffAccessToken = try accessTokenProvider.signAccessToken(for: jwtPayload)
        
        let session = FFSession(accessToken: ffAccessToken, refreshToken: ffRefreshToken)
        return FFSessionResponse(user: ffUser, session: session)
    }
}

// MARK: - Helpers
extension AuthenticationController {
    func createSession(for ffUser: FFUser, on req: Request) async throws -> FFSessionResponse {
        // Generate tokens
        let accessToken = try accessTokenProvider.generateAccessToken(for: ffUser)
        let refreshToken = try await refreshTokenProvider.generateRefreshToken(for: ffUser, database: req.db)
        
        // Return session
        let ffSession = FFSession(accessToken: accessToken, refreshToken: refreshToken)
        return FFSessionResponse(user: ffUser, session: ffSession)
    }
}
