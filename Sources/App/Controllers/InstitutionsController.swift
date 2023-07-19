//
//  InstitutionsController.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import FFAPI
import Factory
import Vapor

final class InstitutionsController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.institutionProvider) private var provider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let institutionRoutes = routes.grouped("institutions")
        institutionRoutes.get("", use: getInstitutions)
        institutionRoutes.post("", use: postInstitutions)
    }
}

// MARK: - Public Requests
extension InstitutionsController {
    func getInstitutions(req: Request) async throws -> FFGetInstitutionsResponse {
        do {
            let body = try req.content.decode(FFGetInstitutionsRequestBody.self)
            let institutions = try await provider.institutions(userID: body.userID, database: req.db)
            return FFGetInstitutionsResponse(institutions: institutions)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get Institutions. Error: \(error)")
        }
    }
    
    func postInstitutions(req: Request) async throws -> FFPostInstitutionsResponse {
        do {
            let body = try req.content.decode(FFPostInstitutionsRequestBody.self)
            try await provider.save(body.institutions, database: req.db)
            let institutions = try await provider.institutions(userID: body.userID, database: req.db)
            return FFPostInstitutionsResponse(institutions: institutions)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to post Institutions. Error: \(error)")
        }
    }
}
