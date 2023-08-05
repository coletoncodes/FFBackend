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
    func findInstitutionBy(_ plaidAccessToken: String, on db: Database) async throws -> Institution
    func delete(_ institution: Institution, on db: Database) async throws
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
    
    func findInstitutionBy(_ plaidAccessToken: String, on db: Database) async throws -> Institution {
        guard let institution = try await Institution.query(on: db)
            .filter(\.$plaidAccessToken == plaidAccessToken)
            .with(\.$accounts)
            .first() else {
            throw Abort(.internalServerError, reason: "No institution found")
        }
        return institution
    }
    
    func delete(_ institution: Institution, on db: Database) async throws {
        let existingInstitution =
        try await findInstitutionBy(institution.plaidAccessToken, on: db)
        try await existingInstitution.delete(on: db)
    }
}
