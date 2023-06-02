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
    private var userStore: UserStore
    
    // MARK: - Initializer
    init(
        accessTokenProvider: AccessTokenProviding = AccessTokenProvider(),
        userStore: UserStore = UserRepository()
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.userStore = userStore
    }
    
    // MARK: - Interface
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        do {
            // Verify token
            let jwtPayload = try accessTokenProvider.validateAccessToken(token)
            // Verify user exists.
            let _ = try await userStore.find(byID: jwtPayload.userID, on: request.db)
        } catch {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
