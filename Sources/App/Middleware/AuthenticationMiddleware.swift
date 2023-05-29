//
//  AuthenticationMiddleware.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Factory
import Vapor
import Fluent

final class AuthenticationMiddleware: AsyncMiddleware {
    @Injected(\.accessTokenProvider) private var accessTokenProvider
    
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        do {
            let _ = try accessTokenProvider.validateAccessToken(token)
        } catch {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
