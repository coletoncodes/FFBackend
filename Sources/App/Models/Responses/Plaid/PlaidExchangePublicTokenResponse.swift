//
//  PlaidExchangePublicTokenResponse.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Vapor

/// The response object returned from Plaid when exchanging the public token.
struct PlaidExchangePublicTokenResponse: Content {
    let access_token: String
    let item_id: String
    let request_id: String
}
