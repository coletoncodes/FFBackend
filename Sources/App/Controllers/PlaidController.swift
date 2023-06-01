//
//  PlaidController.swift
//  
//
//  Created by Coleton Gorecke on 5/18/23.
//

import Factory
import Vapor

final class PlaidController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.userStore) private var userStore
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let plaidRoutes = routes.grouped("plaid")
        plaidRoutes.post("create-link-token", use: createLinkToken)
        plaidRoutes.post("exchange-link-token", use: exchangeLinkToken)
    }
}

// MARK: - Requests
extension PlaidController {
    /// api/plaid/create-link-token
    ///
    /// Creates a link_token using the Plaid API.
    /// Must provide a CreateLinkTokenRequest as the body.
    func createLinkToken(req: Request) async throws -> PlaidCreateLinkTokenResponse {
        // Decode the request body to get the userID
        let requestBody = try req.content.decode(CreateLinkTokenRequest.self)
        
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
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue)
        
        // Wait for response
        let clientResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(body, as: .json)
        }
        
        // Verify it's status .200
        guard clientResponse.status == .ok else {
            throw Abort(.badRequest, reason: "Plaid API request failed")
        }
        
        // Return the response
        return try clientResponse.content.decode(PlaidCreateLinkTokenResponse.self)
    }
    
    /// api/plaid/exchange-link-token
    ///
    /// Exchanges the linkToken for a public access token.
    func exchangeLinkToken(req: Request) async throws -> Response {
        // Extract the public_token from the request
        guard let publicToken = req.query[String.self, at: "public_token"] else {
            throw Abort(.badRequest, reason: "Missing public_token in request")
        }
        
        // Here you can process the public_token, such as exchanging it for an access_token.
        // You should use Plaid's API for this.
        // Store securely, with the related user.
        
        // As an example, here's a placeholder response
        let response = Response()
        response.body = .init(string: "Received public_token: \(publicToken)")
        return response
    }
}

struct PlaidExchangeLinkTokenRequest: Content {
    let client_id: String
    let secret: String
    let public_token: String
    
    init(public_token: String) {
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
        self.public_token = public_token
    }
}
