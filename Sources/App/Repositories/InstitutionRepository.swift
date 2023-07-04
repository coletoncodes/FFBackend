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
    func findInstitution(by institutionID: UUID, on db: Database) async throws -> Institution?
    func delete(by institutionID: UUID, on db: Database) async throws
}

final class InstitutionRepository: InstitutionStore {
    func getInstitutions(userID: UUID, from db: Database) async throws -> [Institution] {
        try await Institution.query(on: db)
            .filter(\.user.$id == userID)
            .all()
    }
    
    func save(_ institution: Institution, on db: Database) async throws {
        try await institution.save(on: db)
    }
    
    func findInstitution(by institutionID: UUID, on db: Database) async throws -> Institution? {
        try await Institution.query(on: db)
            .filter(\.$id == institutionID)
            .first()
    }
    
    func delete(by institutionID: UUID, on db: Database) async throws {
        if let foundInstitution = try await findInstitution(by: institutionID, on: db) {
            try await foundInstitution.delete(on: db)
        }
    }
}
