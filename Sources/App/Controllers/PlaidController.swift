//
//  PlaidController.swift
//  
//
//  Created by Coleton Gorecke on 5/18/23.
//

import Vapor

final class PlaidController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let plaidRoutes = routes.grouped("plaid")
        plaidRoutes.get("redirect", use: handleRedirect)
        plaidRoutes.get("create-link-token", use: createLinkToken)
    }
    
    /// /plaid/redirect
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
    
    /// /plaid/create-link-token
    ///
    /// Creates a link_token using the Plaid API
    func createLinkToken(req: Request) async throws -> Response {
        // TODO: Convert to non sandbox, probably.
        let url = "https://sandbox.plaid.com/link/token/create"
        
        let body = PlaidLinkTokenCreateRequest(
            client_id: "644d45b175067100187e30eb",
            secret: "787992f3ee35e6df430a4fd1f28446",
            client_name: "FinanceFlow",
            user: ["client_user_id": "user-id"],
            products: ["auth", "transactions"],
            country_codes: ["US"],
            language: "en",
            webhook: "https://sample-web-hook.com",
            redirect_uri: "\(Constants.baseURL)/plaid/redirect",
            account_filters: ["depository": ["account_subtypes": ["checking", "savings"]]]
        )
        
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

// TODO: Move These
struct PlaidLinkTokenCreateRequest: Content {
    let client_id: String
    let secret: String
    let client_name: String
    let user: [String: String]
    let products: [String]
    let country_codes: [String]
    let language: String
    let webhook: String
    let redirect_uri: String
    let account_filters: [String: [String: [String]]]
}

struct PlaidLinkTokenCreateResponse: Content {
    let link_token: String
}
