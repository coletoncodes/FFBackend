//
//  PlaidExchangePublicTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Vapor

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
