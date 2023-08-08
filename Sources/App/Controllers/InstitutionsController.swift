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
        institutionRoutes.post("balance", use: getBalance)
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
            return FFGetInstitutionsResponse(institutions: institutions)
        } catch {
            req.logger.error("\(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Failed to get Institutions.", error: error)
        }
    }
    
    /// Fetches the latest balance for all of the BankAccounts for a provided institution.
    func getBalance(req: Request) async throws -> FFRefreshBalanceResponse {
        do {
            // Decode the body
            let requestBody = try req.content.decode(FFRefreshBalanceRequestBody.self)
            let plaidAccessToken = requestBody.institution.plaidAccessToken
            let existingInstitution = try await provider.institutionMatching(plaidAccessToken, on: req.db)
            let accountIDs = existingInstitution.accounts.map { $0.accountID }
            
            guard !accountIDs.isEmpty else {
                throw Abort(.internalServerError, reason: "AccountIDs are empty. Can't fetch balance details for empty accounts.")
            }
            
            // Request details from Plaid.
            let itemDetailsRequest = PlaidItemDetailsRequest(accessToken: plaidAccessToken, plaidInstitutionAccountIds: accountIDs)
            let detailsResponse = try await plaidAPIService.itemDetails(req: req, itemDetailsRequest: itemDetailsRequest)
            
            // Save the updated accounts.
            let bankAccounts = detailsResponse.accounts.map { BankAccount(from: $0, institutionID: existingInstitution.id) }
            try await bankAccountStore.save(bankAccounts, on: req.db)
            
            return FFRefreshBalanceResponse(institution: existingInstitution)
        } catch {
            req.logger.error("\(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Failed to get Balances for institution.", error: error)
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
