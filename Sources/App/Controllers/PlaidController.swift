//
//  PlaidController.swift
//  
//
//  Created by Coleton Gorecke on 5/18/23.
//

import FFAPI
import Factory
import Vapor

final class PlaidController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.userStore) private var userStore
    @Injected(\.plaidAccessTokenStore) private var plaidAccessTokenStore
    @Injected(\.institutionStore) private var institutionStore
    @Injected(\.bankAccountStore) private var bankAccountStore
    
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
        
        let exchangePublicTokenResponse = try await exchangePublicToken(req: req, publicTokenRequest: exchangePublicTokenRequest, metadata: requestBody.metadata)
        
        guard exchangePublicTokenResponse == .ok else {
            throw Abort(.internalServerError, reason: "Failed to exchange public token")
        }
        
        return .ok
    }
}

// MARK: - Internal Requests
extension PlaidController {
    /// Exchanges the public token for an access token for the linked item using the Plaid API.
    ///
    /// Must provide a `ExchangeLinkTokenRequest` as the body.
    func exchangePublicToken(
        req: Request,
        publicTokenRequest: ExchangePublicTokenRequest,
        metadata: FFPlaidSuccessMetadata
    ) async throws -> HTTPStatus {
        // Check if the user exists in the database
        guard let foundUser = try await userStore.find(byID: publicTokenRequest.userID, on: req.db) else {
            throw Abort(.notFound, reason: "Unable to find a user with id: \(publicTokenRequest.userID)")
        }
        
        // Verify the foundUser's id isn't nil.
        guard let userID = foundUser.id else {
            throw Abort(.internalServerError, reason: "Missing ID for User.")
        }
        
        // Create request body.
        let body = PlaidExchangePublicTokenRequest(public_token: publicTokenRequest.publicToken)
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue + "/item/public_token/exchange")
        
        // Wait for response
        let exchangeTokenResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(body, as: .json)
        }
        
        guard exchangeTokenResponse.status == .ok else {
            throw Abort(exchangeTokenResponse.status, reason: "Unable to exchange token")
        }
        
        let publicTokenResponse = try exchangeTokenResponse.content.decode(PlaidExchangePublicTokenResponse.self)
        
        let plaidAccessToken = PlaidAccessToken(userID: userID, accessToken: publicTokenResponse.access_token)
        try await plaidAccessTokenStore.save(plaidAccessToken, on: req.db)
        
        guard let accessTokenID = plaidAccessToken.id else {
            throw Abort(.internalServerError, reason: "Failed to determine accessToken")
        }
        
        let accountIDs = metadata.accounts.map { $0.id }
        
        let institutionDetailsRequest = PlaidItemDetailsRequest(accessToken: plaidAccessToken.accessToken, plaidInstitutionAccountIds: accountIDs)
        let detailsResponse = try await itemDetails(req: req, itemDetailsRequest: institutionDetailsRequest)
        
        let institution = Institution(
            accessTokenID: accessTokenID,
            userID: userID,
            plaidItemID: metadata.institution.id,
            name: metadata.institution.name
        )
        
        try await institutionStore.save(institution, on: req.db)
        let savedInstitution = try await institutionStore.findInstitutionBy(institution.plaidItemID, on: req.db)
        
        guard let institutionID = savedInstitution.id else {
            throw Abort(.internalServerError, reason: "Institution ID value was nil.")
        }
        
        let bankAccounts = detailsResponse.accounts.map { BankAccount(from: $0, institutionID: institutionID) }
        
        try await bankAccountStore.save(bankAccounts, on: req.db)
        
        return .ok
    }
    
    func itemDetails(req: Request, itemDetailsRequest: PlaidItemDetailsRequest) async throws -> PlaidItemDetailsResponse {
        // Create Client URL
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue + "/accounts/balance/get")
        
        // Wait for response
        let clientResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(itemDetailsRequest, as: .json)
        }
        
        // Verify it's status .200
        guard clientResponse.status == .ok else {
            throw Abort(.badRequest, reason: "Plaid Item Details request failed with status: \(clientResponse.status) and error: \(clientResponse.description)")
        }
        
        return try clientResponse.content.decode(PlaidItemDetailsResponse.self)
    }
}

fileprivate extension BankAccount {
    convenience init(from plaidAccount: PlaidAccount, institutionID: UUID) {
        self.init(
            institutionID: institutionID,
            accountID: plaidAccount.account_id,
            name: plaidAccount.name,
            subtype: plaidAccount.subtype,
            isSyncingTransactions: true,
            currentBalance: plaidAccount.balances.current
        )
    }
}
