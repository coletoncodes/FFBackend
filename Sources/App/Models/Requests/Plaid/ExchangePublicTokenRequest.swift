//
//  ExchangePublicTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Vapor

/// The Request object Client applications must provide to get an access token for a linked item.
struct ExchangePublicTokenRequest: Content {
    let userID: UUID
    let publicToken: String
}

struct PlaidExchangePublicTokenRequest: Content {
    let public_token: String
    let client_id: String
    let secret: String
    
    init(public_token: String) {
        self.public_token = public_token
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
    }
}
