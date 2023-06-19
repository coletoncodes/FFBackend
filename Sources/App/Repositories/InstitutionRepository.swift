//
//  InstitutionRepository.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Fluent
import Vapor

protocol InstitutionStore {
    func save(_ institution: Institution, on db: Database) async throws
    func findInstitution(by ID: UUID, on db: Database) async throws -> Institution?
    func delete(_ institution: Institution, on db: Database) async throws
}

final class InstitutionRepository: InstitutionStore {
    func save(_ institution: Institution, on db: Database) async throws {
        try await institution.save(on: db)
    }
    
    func findInstitution(by ID: UUID, on db: Database) async throws -> Institution? {
        try await Institution.query(on: db)
            .filter(\.$id == ID)
            .first()
    }
    
    func delete(_ institution: Institution, on db: Database) async throws {
        try await institution.delete(on: db)
    }
}
