//
//  PlaidLinkController.swift
//  
//
//  Created by Coleton Gorecke on 5/18/23.
//

import FFAPI
import Factory
import Vapor

final class PlaidLinkController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.plaidAPIService) private var plaidAPIService
    @Injected(\.userStore) private var userStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let plaidRoutes = routes.grouped("plaid")
        plaidRoutes.post("create-link-token", use: createLinkToken)
        plaidRoutes.post("link-success", use: linkSuccess)
    }
}

// MARK: - Public Requests
extension PlaidLinkController {
    /// api/plaid/create-link-token
    ///
    /// Creates a link_token using the Plaid API.
    ///
    /// Must provide a `PlaidCreateLinkTokenRequest` as the body.
    func createLinkToken(req: Request) async throws -> FFCreateLinkTokenResponse {
        // Decode the request body to get the userID
        let requestBody = try req.content.decode(FFCreateLinkTokenRequestBody.self)
        
        // Check if the user exists in the database
        guard let foundUser = try await userStore.find(byID: requestBody.userID, on: req.db) else {
            throw Abort(.notFound, reason: "Unable to find a user with id: \(requestBody.userID)")
        }
        
        // Verify the foundUser's id isn't nil.
        guard let userID = foundUser.id else {
            throw Abort(.internalServerError, reason: "Missing ID for User.")
        }
        
        // Create request body.
        let plaidUser = PlaidUser(client_user_id: String(userID))
        let body = PlaidCreateLinkTokenRequest(user: plaidUser)
        
        // Create Client URL
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue + "/link/token/create")
        
        // Wait for response
        let clientResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(body, as: .json)
        }
        
        // Verify it's status .200
        guard clientResponse.status == .ok else {
            throw Abort(.badRequest, reason: "Plaid API request failed with status: \(clientResponse.status) and error: \(clientResponse.description)")
        }
        
        let response = try clientResponse.content.decode(PlaidCreateLinkTokenResponse.self)
        return FFCreateLinkTokenResponse(linkToken: response.link_token)
    }
    
    /// Handles the linkSuccess from the client and saves the data into the database.
    ///
    /// api/plaid/link-success
    ///
    /// Must provide a `LinkSuccessRequest` as the body.
    func linkSuccess(req: Request) async throws -> HTTPStatus {
        // Decode the request
        let requestBody = try req.content.decode(FFLinkSuccessRequestBody.self)
        
        // Create the exchange public token request
        let exchangePublicTokenRequest = ExchangePublicTokenRequest(userID: requestBody.userID, publicToken: requestBody.publicToken)
        
        let exchangePublicTokenResponse = try await plaidAPIService.exchangePublicToken(req: req, publicTokenRequest: exchangePublicTokenRequest, metadata: requestBody.metadata)
        
        guard exchangePublicTokenResponse == .ok else {
            throw Abort(.internalServerError, reason: "Failed to exchange public token")
        }
        
        return .ok
    }
}
