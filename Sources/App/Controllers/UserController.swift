//
//  UserController.swift
//  
//
//  Created by Coleton Gorecke on 5/13/23.
//

import Fluent
import Vapor
import Crypto

struct UserController: RouteCollection {
    // TODO: Move to DI
    private let userRepo: UserStore = UserRepository()
    
    init() { }
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        routes.group("users") { users in
            users.get(":userID", use: getUser)
            users.put(":userID", use: updateUser)
            users.delete(":userID", use: deleteUser)
        }
    }
}

// MARK: - Requests
extension UserController {
    func getUser(_ req: Request) async throws -> User {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid User ID.")
        }
        
        guard let foundUser = try await userRepo.find(byID: userID, on: req.db) else {
            throw Abort(.notFound, reason: "Unable to find a user with id: \(userID)")
        }
        
        return foundUser
    }
    
    func updateUser(_ req: Request) async throws -> User {
        guard let _ = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing User ID")
        }
        
        let updatedUser = try req.content.decode(User.self)
        return try await userRepo.update(user: updatedUser, on: req.db)
    }
    
    func deleteUser(_ req: Request) async throws -> HTTPStatus {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid User ID.")
        }
        
        try await userRepo.delete(userID: userID, on: req.db)
        return .ok
    }
}
