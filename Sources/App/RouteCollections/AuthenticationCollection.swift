//
//  AuthenticationCollection.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Fluent
import Vapor

struct AuthenticationCollection: RouteCollection {
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            auth.post("login", use: login)
        }
    }
}

// MARK: - Requests
private extension AuthenticationCollection {
    /// Register's the user and save to the database.
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
        return LoginResponse(user: UserDTO(from: user))
    }
    
    /// Log the user in
    func login(_ req: Request) async throws -> LoginResponse {
        do {
            try LoginRequest.validate(content: req)
        } catch {
            let logStr = "Invalid request data: \(error)"
            throw Abort(.badRequest, reason: logStr)
        }
        
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$email == loginRequest.email).first() else {
            throw Abort(.unauthorized)
        }
        
        do {
            let passwordVerified = try Bcrypt.verify(loginRequest.password, created: user.passwordHash)
            
            if passwordVerified {
                return LoginResponse(user: UserDTO(from: user))
            } else {
                throw Abort(.unauthorized)
            }
        } catch {
            let logStr = "Password verification failed: \(error)"
            throw Abort(.internalServerError, reason: logStr)
        }
    }
}
