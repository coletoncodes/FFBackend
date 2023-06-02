//
//  PlaidCreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Vapor

/// The Request object to pass to PlaidAPI to create a link token.
///
/// [Documentation](https://plaid.com/docs/api/tokens/#linktokencreate)
struct PlaidCreateLinkTokenRequest: Content {
    let client_id: String
    let secret: String
    let client_name: String
    let user: PlaidUser
    let products: [String]
    let country_codes: [String]
    let language: String
    
    init(user: PlaidUser) {
        // TODO: Move to environment
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
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
