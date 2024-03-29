//
//  PlaidAPIService.swift
//  
//
//  Created by Coleton Gorecke on 8/4/23.
//

import Factory
import Foundation
import FFAPI
import Vapor

final class PlaidAPIService {
    // MARK: - Dependencies
    @Injected(\.userStore) private var userStore
    @Injected(\.plaidAccessTokenStore) private var plaidAccessTokenStore
    @Injected(\.institutionStore) private var institutionStore
    @Injected(\.bankAccountStore) private var bankAccountStore
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
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
        
        guard let plaidAccessTokenID = plaidAccessToken.id else {
            throw Abort(.internalServerError, reason: "Nil ID for PlaidAccessToken.")
        }
        
        let institution = Institution(
            plaidAccessTokenID: plaidAccessTokenID,
            userID: userID,
            name: metadata.institution.name
        )
        
        try await institutionStore.save(institution, on: req.db)
        let savedInstitution = try await institutionStore.findInstitutionByPlaidAccessToken(with: plaidAccessTokenID, on: req.db)
        
        guard let institutionID = savedInstitution.id else {
            throw Abort(.internalServerError, reason: "Institution ID value was nil.")
        }
        
        let bankAccounts = metadata.accounts.map { BankAccount(from: $0, institutionID: institutionID)}
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
    
    func syncTransactions(req: Request, for plaidAccessToken: PlaidAccessToken) async throws -> PlaidTransactionSyncResponse {
        // Create Client URL
        let clientURI = URI(string: Constants.plaidBaseURL.rawValue + "/transactions/sync")
        
        // TODO: Get the last saved curser for the plaidItem, if empty, can keep as empty or maybe nil?
        let request = PlaidTransactionSyncRequest(plaidItemAccessToken: plaidAccessToken.accessToken, cursor: "")
        
        // Wait for response
        let clientResponse = try await req.client.post(clientURI) { req in
            try req.content.encode(request, as: .json)
        }
        
        // Verify it's status .200
        guard clientResponse.status == .ok else {
            throw Abort(.badRequest, reason: "Plaid Sync Transactions request failed with status: \(clientResponse.status) and error: \(clientResponse.description)")
        }
        
        return try clientResponse.content.decode(PlaidTransactionSyncResponse.self)
    }
}

fileprivate extension BankAccount {
    convenience init(from ffPlaidAccount: FFPlaidAccount, institutionID: UUID) {
        self.init(
            institutionID: institutionID,
            accountID: ffPlaidAccount.id,
            name: ffPlaidAccount.name,
            subtype: ffPlaidAccount.subtype,
            isSyncingTransactions: true,
            currentBalance: 0.0
        )
    }
}
