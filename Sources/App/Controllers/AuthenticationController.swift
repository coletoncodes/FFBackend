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
    private var accessTokenProvider: AccessTokenProviding
    private var refreshTokenProvider: RefreshTokenProviding
    private var refreshTokenStore: RefreshTokenStore
    private var userStore: UserStore
    
    // MARK: - Initializer
    init(
        accessTokenProvider: AccessTokenProviding = AccessTokenProvider(),
        refreshTokenProvider: RefreshTokenProviding = RefreshTokenProvider(),
        refreshTokenStore: RefreshTokenStore = RefreshTokenRepository(),
        userStore: UserStore = UserRepository()
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.refreshTokenProvider = refreshTokenProvider
        self.refreshTokenStore = refreshTokenStore
        self.userStore = userStore
    }
    
    
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
        try await userStore.save(user, on: req.db)
        
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
        guard let refreshToken = req.headers["x-refresh-token"].first else {
            throw Abort(.unauthorized, reason: "Missing refresh token in header")
        }
        
        // Validate the refresh token
        let refreshTokenDTO: RefreshTokenDTO
        do {
            refreshTokenDTO = try await refreshTokenProvider.validateRefreshToken(refreshToken, on: req)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid refresh token. Please log in again.")
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
    
    /// Log's the user out and deletes the user's latest RefreshToken from the Database.
    /// - Parameter req: The incoming `Request`, which should contain the refresh token in the authorization header.
    /// - Returns: .ok if successfully deleted the token.
    func logout(_ req: Request) async throws -> HTTPStatus {
        // Verify userID is provided in request.
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing User ID in request.")
        }
        
        // Get the user for the userID
        guard let user = try await userStore.find(byID: userID, on: req.db) else {
            throw Abort(.notFound, reason: "No User exists for the given id: \(userID)")
        }
        
        guard let refreshToken = try await refreshTokenStore.findToken(for: user, on: req.db) else {
            throw Abort(.unauthorized, reason: "No refresh token's exist for the given user.")
        }
        
        // Invalidate the refreshToken. Removing access completely.
        try await refreshTokenProvider.invalidate(refreshToken.token, on: req)
        
        // Return success
        return .ok
    }
    
    func loadSession(_ req: Request) async throws -> SessionResponse {
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
        do {
            _ = try await refreshTokenProvider.validateRefreshToken(refreshToken, on: req)
        } catch {
            throw Abort(.unauthorized, reason: "Refresh token is invalid. Please login again.")
        }
        
        // Ensure we have a valid JWT payload to work with (either from a valid access token, or a valid refresh token)
        guard let jwtPayload = jwtPayload else {
            throw Abort(.internalServerError, reason: "Unable to process JWT payload.")
        }

        // Check if the refresh token corresponds to the same user as the access token
        guard let user = try await userStore.find(byID: jwtPayload.userID, on: req.db) else {
            throw Abort(.unauthorized, reason: "No user exists for this id.")
        }

        // Whether access token was valid or not,
        // we now create a new session as we have a valid refresh token
        return try await createSession(for: user, on: req)
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
