//
//  PlaidCreateLinkTokenResponse.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Vapor

/// The Response object returned from PlaidAPI to create a link token.
///
/// [Documentation](https://plaid.com/docs/api/tokens/#linktokencreate)
struct PlaidCreateLinkTokenResponse: Content {
    let link_token: String
    let expiration: Date
    let request_id: String
}
