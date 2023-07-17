//
//  AuthenticationMiddleware.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Factory
import Vapor
import Fluent
import PostgresKit

final class AuthenticationMiddleware: AsyncMiddleware {
    // MARK: - Dependencies
    @Injected(\.accessTokenProvider) private var accessTokenProvider
    @Injected(\.refreshTokenProvider) private var refreshTokenProvider
    @Injected(\.userStore) private var userStore
    
    // MARK: - Interface
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let accessToken = request.headers.bearerAuthorization?.token else {
            throw Abort(.internalServerError, reason: "Missing access token in header")
        }
        
        // Verify refresh token exists
        guard let refreshToken = request.headers["x-refresh-token"].first else {
            throw Abort(.unauthorized, reason: "Missing refresh token value in header")
        }
        
        do {
            let _ = try accessTokenProvider.validateAccessToken(accessToken)
        } catch {
            throw Abort(.unauthorized, reason: "Access token is expired")
        }
        
        do {
            let _ = try await refreshTokenProvider.validateRefreshToken(refreshToken, database: request.db)
        } catch {
            throw Abort(.unauthorized, reason: "Refresh token is expired")
        }
        
        return try await next.respond(to: request)
    }
}

struct DatabaseErrorMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch let psqlError as PSQLError {
            print("PSQLError: \(String(reflecting: psqlError))")
            print("PSQLError Code: \(psqlError.code)")
            print("PSQLError Underlying: \(String(describing: psqlError.underlying))")
            print("PSQLError localized description: \(psqlError.localizedDescription)")
            print("PSQLError failing query: \(String(describing: psqlError.query))")
            
            // Create and throw an appropriate Abort error for PSQLError
            throw Abort(.conflict, reason: "A PSQLError occurred.")
        } catch {
            // Throw a generic Abort error for other types of errors
            throw error
        }
    }
}

