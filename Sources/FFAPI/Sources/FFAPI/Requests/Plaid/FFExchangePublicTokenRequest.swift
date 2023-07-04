//
//  FFExchangePublicTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Foundation

/// The Request object Client applications must provide to get an access token for a linked item.
public struct FFExchangePublicTokenRequest: Codable {
    public let userID: UUID
    public let publicToken: String
    
    public init(userID: UUID, publicToken: String) {
        self.userID = userID
        self.publicToken = publicToken
    }
}

// TODO: Move to FFBackend
//struct PlaidExchangePublicTokenRequest: Codable {
//    let public_token: String
//    let client_id: String
//    let secret: String
//
//    init(public_token: String) {
//        self.public_token = public_token
//        self.client_id = Constants.plaidClientId.rawValue
//        self.secret = Constants.plaidSecretKey.rawValue
//    }
//}
