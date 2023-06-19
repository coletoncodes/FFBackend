//
//  AuthenticationMiddleware.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Vapor
import Fluent

final class AuthenticationMiddleware: AsyncMiddleware {
    // MARK: - Dependencies
    private var accessTokenProvider: AccessTokenProviding
    private var refreshTokenProvider: RefreshTokenProviding
    private var userStore: UserStore

    // MARK: - Initializer
    init(
        accessTokenProvider: AccessTokenProviding = AccessTokenProvider(),
        refreshTokenProvider: RefreshTokenProviding = RefreshTokenProvider(),
        userStore: UserStore = UserRepository()
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.refreshTokenProvider = refreshTokenProvider
        self.userStore = userStore
    }

    // MARK: - Interface
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let accessToken = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Missing access token in header")
        }
        
        // Verify refresh token exists
        guard request.headers.contains(name: "x-refresh-token") else {
            throw Abort(.unauthorized, reason: "Missing x-refresh-token in header")
        }
        
        guard let refreshToken = request.headers["x-refresh-token"].first else {
            throw Abort(.unauthorized, reason: "Missing refresh token value in header")
        }
        
        do {
            let _ = try accessTokenProvider.validateAccessToken(accessToken)
        } catch {
            throw Abort(.unauthorized, reason: "Access token is invalid. Error: \(error)")
        }

        do {
            let _ = try await refreshTokenProvider.validateRefreshToken(refreshToken, on: request)
        } catch {
            throw Abort(.unauthorized, reason: "Refresh token is invalid. Error: \(error)")
        }

        return try await next.respond(to: request)
    }
}

