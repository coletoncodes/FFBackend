//
//  File.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Vapor

/// The request object sent to plaid to exchange a user's public_token for an access token.
struct PlaidExchangePublicTokenRequest: Content {
    let client_id: String
    let secret: String
    let public_token: String
    
    init(public_token: String) {
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
        self.public_token = public_token
    }
}
