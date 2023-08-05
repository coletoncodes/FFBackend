//
//  InstitutionsProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

protocol InstitutionsProviding {
    func institutions(userID: UUID, database: Database) async throws -> [FFInstitution]
    func save(_ ffInstitution: FFInstitution, database: Database) async throws
    func save(_ ffInstitutions: [FFInstitution], database: Database) async throws
    func institutionMatching(_ plaidAccessToken: String, on db: Database) async throws -> FFInstitution
}

final class InstitutionsProvider: InstitutionsProviding {
    // MARK: - Dependencies
    @Injected(\.institutionStore) private var institutionStore
    
    // MARK: - Interface
    func institutions(userID: UUID, database: Database) async throws -> [FFInstitution] {
        try await institutionStore.getInstitutions(userID: userID, from: database)
            .map { try FFInstitution(from: $0) }
    }
    
    func save(_ ffInstitution: FFInstitution, database: Database) async throws {
        let institution = Institution(from: ffInstitution)
        try await institutionStore.save(institution, on: database)
    }
    
    func save(_ ffInstitutions: [FFInstitution], database: Database) async throws {
        for institution in ffInstitutions {
            try await save(institution, database: database)
        }
    }
    
    func institutionMatching(_ plaidAccessToken: String, on db: Database) async throws -> FFInstitution {
        let institution = try await institutionStore.findInstitutionBy(plaidAccessToken, on: db)
        return try FFInstitution(from: institution)
    }
}
