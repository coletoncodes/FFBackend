//
//  UserRepository.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor
import Fluent

protocol UserStore {
    func find(byEmail email: String, on db: Database) async throws -> User?
    func find(byID uuid: UUID, on db: Database) async throws -> User?
    func create(user: User, on db: Database) async throws -> User
    func update(user: User, on db: Database) async throws -> User
    func delete(userID: UUID, on db: Database) async throws
}

final class UserRepository: UserStore {
    func find(byEmail email: String, on db: Database) async throws -> User? {
        try await User.query(on: db)
            .filter(\.$email == email)
            .first()
    }
    
    func find(byID uuid: UUID, on db: Database) async throws -> User? {
        try await User.query(on: db)
            .filter(\.$id == uuid)
            .first()
    }
    
    func create(user: User, on db: Database) async throws -> User {
        try await user.save(on: db)
        return user
    }
    
    func update(user: User, on db: Database) async throws -> User {
        try await user.update(on: db)
        return user
    }
    
    func delete(userID: UUID, on db: Database) async throws {
        guard let user = try await User.find(userID, on: db) else {
            throw Abort(.notFound, reason: "User with ID \(userID) not found.")
        }
        try await user.delete(on: db)
    }
}
