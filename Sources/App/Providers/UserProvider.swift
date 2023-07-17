//
//  UserProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import FFAPI
import Factory
import Vapor

protocol UserProviding {
    // TODO: Replace req with database
    func save(ffUser: FFUser, from req: Request) async throws
    func findBy(email: String, from req: Request) async throws -> FFUser?
    func findBy(id: UUID, from req: Request) async throws -> FFUser?
}

final class UserProvider: UserProviding {
    // MARK: - Dependencies
    @Injected(\.userStore) private var userStore
    
    // MARK: - Interface
    func save(ffUser: FFUser, from req: Request) async throws {
        let user = User(from: ffUser)
        return try await userStore.save(user, on: req.db)
    }
    
    func findBy(email: String, from req: Request) async throws -> FFUser? {
        guard let user = try await userStore.find(byEmail: email, on: req.db) else {
            return nil
        }
        
        return FFUser(from: user)
    }
    
    func findBy(id: UUID, from req: Request) async throws -> FFUser? {
        guard let user = try await userStore.find(byID: id, on: req.db) else {
            return nil
        }
        
        return FFUser(from: user)
    }
}
