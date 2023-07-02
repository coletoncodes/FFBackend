//
//  UserProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import Factory
import Vapor

protocol UserProviding {
    func save(userDTO: UserDTO, from req: Request) async throws
    func findBy(email: String, from req: Request) async throws -> UserDTO?
    func findBy(id: UUID, from req: Request) async throws -> UserDTO?
}

final class UserProvider: UserProviding {
    // MARK: - Dependencies
    @Injected(\.userStore) private var userStore
    
    // MARK: - Interface
    func save(userDTO: UserDTO, from req: Request) async throws {
        let user = try User(from: userDTO)
        return try await userStore.save(user, on: req.db)
    }
    
    func findBy(email: String, from req: Request) async throws -> UserDTO? {
        guard let user = try await userStore.find(byEmail: email, on: req.db) else {
            return nil
        }
        
        return UserDTO(from: user)
    }
    
    func findBy(id: UUID, from req: Request) async throws -> UserDTO? {
        guard let user = try await userStore.find(byID: id, on: req.db) else {
            return nil
        }
        
        return UserDTO(from: user)
    }
}
