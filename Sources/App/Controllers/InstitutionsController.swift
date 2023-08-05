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
    @Injected(\.plaidAPIService) private var plaidAPIService
    @Injected(\.bankAccountStore) private var bankAccountStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let institutionRoutes = routes.grouped("institutions")
        institutionRoutes.get(":userID", use: getInstitutions)
        institutionRoutes.post("", use: postInstitutions)
    }
}

// MARK: - Public Requests
extension InstitutionsController {
    func getInstitutions(req: Request) async throws -> FFGetInstitutionsResponse {
        do {
            guard let userID = req.parameters.get("userID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No USERID in URL.")
            }
            
            let institutions = try await provider.institutions(userID: userID, database: req.db)
            try await updateAccounts(req: req, for: institutions)
            return FFGetInstitutionsResponse(institutions: institutions)
        } catch {
            req.logger.error("\(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Failed to get Institutions.", error: error)
        }
    }
    
    func updateAccounts(req: Request, for institutions: [FFInstitution]) async throws {
        for institution in institutions {
            let accountIDs = institution.accounts.map { $0.accountID }
            let itemDetailsRequest = PlaidItemDetailsRequest(accessToken: institution.plaidAccessToken, plaidInstitutionAccountIds: accountIDs)
            let detailsResponse = try await plaidAPIService.itemDetails(req: req, itemDetailsRequest: itemDetailsRequest)
            
            let bankAccounts = detailsResponse.accounts.map { BankAccount(from: $0, institutionID: institution.id) }
            try await bankAccountStore.save(bankAccounts, on: req.db)
        }
    }
}

// MARK: - Internal Requests
extension InstitutionsController {
    func postInstitutions(req: Request) async throws -> FFPostInstitutionsResponse {
        do {
            let body = try req.content.decode(FFPostInstitutionsRequestBody.self)
            try await provider.save(body.institutions, database: req.db)
            let institutions = try await provider.institutions(userID: body.userID, database: req.db)
            return FFPostInstitutionsResponse(institutions: institutions)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to post Institutions", error: error)
        }
    }
}
