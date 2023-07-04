//
//  InstitutionsProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import FFAPI
import Foundation
import Factory
import Vapor

protocol InstitutionsProviding {
    func institutions(userID: UUID, request: Request) async throws -> [FFInstitution]
}

final class InstitutionsProvider: InstitutionsProviding {
    // MARK: - Dependencies
    @Injected(\.institutionStore) private var institutionStore
    
    // MARK: - Interface
    func institutions(userID: UUID, request: Request) async throws -> [FFInstitution] {
        try await institutionStore.getInstitutions(userID: userID, from: request.db)
            .map { FFInstitution(from: $0) }
    }
}
