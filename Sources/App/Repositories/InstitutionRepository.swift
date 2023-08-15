//
//  InstitutionRepository.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Vapor

protocol InstitutionStore {
    func getInstitutions(userID: UUID, from db: Database) async throws -> [Institution]
    func save(_ institution: Institution, on db: Database) async throws
    func findInstitutionByPlaidAccessToken(with id: PlaidAccessToken.IDValue, on db: Database) async throws -> Institution
    func delete(_ institution: Institution, on db: Database) async throws
    func findInstitutionMatching(_ id: Institution.IDValue, on db: Database) async throws -> Institution
}

final class InstitutionRepository: InstitutionStore {
    func getInstitutions(userID: UUID, from db: Database) async throws -> [Institution] {
        try await Institution.query(on: db)
            .filter(\.$user.$id == userID)
            .with(\.$accounts)
            .all()
    }
    
    func save(_ institution: Institution, on db: Database) async throws {
        try await institution.save(on: db)
    }
    
    func findInstitutionByPlaidAccessToken(with id: PlaidAccessToken.IDValue, on db: Database) async throws -> Institution {
        guard let institution = try await Institution
            .query(on: db)
            .filter(\.$plaidAccessToken.$id == id)
            .with(\.$accounts)
            .first() else {
            throw Abort(.internalServerError, reason: "No institution with matching plaidAccessTokenID: \(id)")
        }
        return institution
    }
    
    func findInstitutionMatching(_ id: Institution.IDValue, on db: Database) async throws -> Institution {
        guard let foundInstitution = try await Institution
            .query(on: db)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.internalServerError, reason: "Failed to find matching institution.")
        }
        return foundInstitution
    }
    
    func delete(_ institution: Institution, on db: Database) async throws {
        guard let existing = try await Institution
            .query(on: db)
            .filter(\.$plaidAccessToken.$id == institution.requireID())
            .filter(\.$user.$id == institution.user.requireID())
            .first()
        else {
            throw Abort(.internalServerError, reason: "Failed to find matching institution.")
        }
        try await existing.delete(on: db)
    }
}
