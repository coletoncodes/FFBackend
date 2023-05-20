//
//  UserController.swift
//  
//
//  Created by Coleton Gorecke on 5/13/23.
//

import Fluent
import Vapor
import Crypto

//struct UserController: RouteCollection {
//    func boot(routes: RoutesBuilder) throws {
//        let users = routes.grouped("users")
//        
//        // Unprotected routes
//        users.post("create", use: create)
//        
//        // Protected routes
//        let passwordProtected = users.grouped(User.authenticator())
//        passwordProtected.post("login", use: login)
//        passwordProtected.get(use: index)
//        passwordProtected.get(":userID", use: read)
//        passwordProtected.put(":userID", use: update)
//        passwordProtected.delete(":userID", use: delete)
//    }
//    
//    /// Verifies the user's email exists in the request, and the database.
//    /// Then saves the token into the database for future requests using token validation.
//    func login(req: Request) async throws -> UserToken {
//        let user = try req.auth.require(User.self)
//        let token = try user.generateToken()
//        try await token.save(on: req.db)
//        return token
//    }
//    
//    // Create user
//    func create(req: Request) async throws -> User {
//        let create = try req.content.decode(User.Create.self)
//        
//        guard create.password == create.confirmPassword else {
//            throw Abort(.badRequest, reason: "Passwords did not match")
//        }
//        
//        let user = try User(
//            name: create.name,
//            email: create.email,
//            passwordHash: Bcrypt.hash(create.password)
//        )
//        
//        try await user.save(on: req.db)
//        return user
//    }
//    
//    // Get all users
//    func index(req: Request) async throws -> [User] {
//        try await User.query(on: req.db).all()
//    }
//    
//    // Get user by ID
//    func read(req: Request) async throws -> User {
//        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return user
//    }
//    
//    // Update user
//    func update(req: Request) async throws -> User {
//        guard let existingUser = try await User.find(req.parameters.get("userID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        let updatedUser = try req.content.decode(User.self)
//        existingUser.name = updatedUser.name
//        existingUser.email = updatedUser.email
//        try await existingUser.save(on: req.db)
//        return existingUser
//    }
//    
//    // Delete user
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        try await user.delete(on: req.db)
//        return .noContent
//    }
//}
