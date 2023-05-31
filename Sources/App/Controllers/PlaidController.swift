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
        plaidRoutes.get("redirect", use: handleRedirect)
        plaidRoutes.get("create-link-token", use: createLinkToken)
    }
}

// MARK: - Requests
extension PlaidController {
    /// api/plaid/redirect
    ///
    /// Handles the redirect and exchanges the public token for an access token
    func handleRedirect(req: Request) async throws -> Response {
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
    
    /// api/plaid/create-link-token
    ///
    /// Creates a link_token using the Plaid API.
    /// Must provide a CreateLinkTokenRequest as the body.
    func createLinkToken(req: Request) async throws -> Response {
        // TODO: Convert to non sandbox, eventually.
        let url = "https://sandbox.plaid.com/link/token/create"
        
        // Decode the request body to get the userID
        let requestBody = try req.content.decode(CreateLinkTokenRequest.self)
        
        // Check if the user exists in the database
        guard let foundUser = try await userStore.find(byID: requestBody.userID, on: req.db) else {
            throw Abort(.notFound, reason: "Unable to find a user with id: \(requestBody.userID)")
        }
        
        guard let userID = foundUser.id else {
            throw Abort(.internalServerError, reason: "Missing ID for User.")
        }
        
        let plaidUser = PlaidUser(client_user_id: String(userID))
        let body = PlaidLinkTokenCreateRequest(user: plaidUser)
        
        let clientResponse = try await req.client.post(URI(string: url)) { req in
            try req.content.encode(body, as: .json)
        }
        
        guard clientResponse.status == .ok else {
            throw Abort(.badRequest, reason: "Plaid API request failed")
        }
        
        let responseBody = try clientResponse.content.decode(PlaidLinkTokenCreateResponse.self)
        
        let response = Response()
        response.body = .init(string: responseBody.link_token)
        return response
    }
}

@frozen enum Constants: String {
    case baseURL = "https://financeflow-api.herokuapp.com/"
}

struct PlaidLinkTokenCreateRequest: Content {
    let client_id: String
    let secret: String
    let client_name: String
    let user: PlaidUser
    let products: [String]
    let country_codes: [String]
    let language: String
    
    init(user: PlaidUser) {
        // TODO: Move to environment
        self.client_id = "644d45b175067100187e30eb"
        self.secret = "787992f3ee35e6df430a4fd1f28446"
        self.client_name = "FinanceFlow"
        self.user = user
        self.products = ["transactions"]
        self.country_codes = ["US"]
        self.language = "en"
    }
}

struct PlaidUser: Content {
    let client_user_id: String
}

struct PlaidLinkTokenCreateResponse: Content {
    let link_token: String
    let expiration: Date
    let request_id: String
}
