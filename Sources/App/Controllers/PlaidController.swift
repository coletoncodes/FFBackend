//
//  PlaidController.swift
//  
//
//  Created by Coleton Gorecke on 5/18/23.
//

import Vapor

final class PlaidController: RouteCollection {
    // MARK: - Dependencies
    private var userStore: UserStore
    private var plaidAccessTokenStore: PlaidAccessTokenStore
    
    // MARK: - Initializer
    init(
        userStore: UserStore = UserRepository(),
        plaidAccessTokenStore: PlaidAccessTokenStore = PlaidAccessTokenRepository()
    ) {
        self.userStore = userStore
        self.plaidAccessTokenStore = plaidAccessTokenStore
    }
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let plaidRoutes = routes.grouped("plaid")
        plaidRoutes.post("create-link-token", use: createLinkToken)
        plaidRoutes.post("link-success", use: linkSuccess)
    }
}

// MARK: - Public Requests
extension PlaidController {
    /// api/plaid/create-link-token
    ///
    /// Creates a link_token using the Plaid API.
    /// Must provide a `CreateLinkTokenRequest` as the body.
    func createLinkToken(req: Request) async throws -> CreateLinkTokenResponse {
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
        return CreateLinkTokenResponse(linkToken: response.link_token)
    }
    
    /// Handles the linkSuccess from the client and saves the data into the database.
    ///
    /// api/plaid/link-success
    ///
    /// Creates a link_token using the Plaid API.
    /// Must provide a `CreateLinkTokenRequest` as the body.
    func linkSuccess(req: Request) async throws -> HTTPStatus {
        return .ok
    }
    
    // TODO: Finish this
    func getTransactions(req: Request) async throws -> HTTPStatus {
        return .ok
    }
}

// MARK: - Internal Requests
extension PlaidController {
    /// Exchanges the public token for an access token for the linked item using the Plaid API.
    ///
    /// Must provide a `ExchangeLinkTokenRequest` as the body.
    func exchangePublicToken(req: Request, publicTokenRequest: ExchangePublicTokenRequest) async throws -> HTTPStatus {
        // Check if the user exists in the database
        guard let foundUser = try await userStore.find(byID: publicTokenRequest.userID, on: req.db) else {
            throw Abort(.notFound, reason: "Unable to find a user with id: \(publicTokenRequest.userID)")
        }
        
        // Verify the foundUser's id isn't nil.
        guard let userID = foundUser.id else {
            throw Abort(.internalServerError, reason: "Missing ID for User.")
        }
        
        // Create request body.
        let body = ExchangePublicTokenRequest(userID: userID, publicToken: publicTokenRequest.publicToken)
        
        // Create Client URL
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue + "/item/public_token/exchange")
        
        // Wait for response
        let clientResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(body, as: .json)
        }
        
        let response = try clientResponse.content.decode(PlaidExchangePublicTokenResponse.self)
        
        // Save the token
        let plaidAccessToken = PlaidAccessToken(userID: userID, accessToken: response.access_token)
        try await plaidAccessTokenStore.save(plaidAccessToken, on: req.db)
        return .ok
    }
}


struct PlaidGetTransactionsRequest: Content {
    let client_id: String
    let secret: String
    let access_token: String
    let start_date: Date
    let end_date: Date
    let options: PlaidTransactionOptions

    init(
        access_token: String,
        start_date: Date,
        end_date: Date
    ) {
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
        self.access_token = access_token
        self.start_date = start_date
        self.end_date = end_date
        self.options = PlaidTransactionOptions()
    }
}

// TODO: Add options if needed
struct PlaidTransactionOptions: Content {
    let include_personal_finance_category: Bool
    
    init() {
        self.include_personal_finance_category = true
    }
}
