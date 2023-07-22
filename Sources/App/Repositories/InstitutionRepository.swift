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
    func findInstitutionBy(_ plaidItemID: String, on db: Database) async throws -> Institution?
    func deleteInstitution(_ plaidItemID: String, on db: Database) async throws
}

final class InstitutionRepository: InstitutionStore {
    func getInstitutions(userID: UUID, from db: Database) async throws -> [Institution] {
        try await Institution.query(on: db)
            .filter(\.$user.$id == userID)
            .all()
    }
    
    func save(_ institution: Institution, on db: Database) async throws {
        if let existing = try await Institution
            .query(on: db)
            .filter(\.$name == institution.name)
            .filter(\.$plaidItemID == institution.plaidItemID)
            .first() {
            try await existing.update(on: db)
        } else {
            try await institution.save(on: db)
        }
    }
    
    func findInstitutionBy(_ plaidItemID: String, on db: Database) async throws -> Institution? {
        try await Institution.query(on: db)
            .filter(\.$plaidItemID == plaidItemID)
            .first()
    }
    
    func deleteInstitution(_ plaidItemID: String, on db: Database) async throws {
        if let foundInstitution = try await findInstitutionBy(plaidItemID, on: db) {
            try await foundInstitution.delete(on: db)
        }
    }
}
