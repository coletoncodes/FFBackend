//
//  PlaidTransactionSyncRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Foundation

struct PlaidTransactionSyncRequest: Codable {
    let client_id: String
    let secret: String
    let access_token: String
    let cursor: String
    let count: Int
    
    init(plaidItemAccessToken: String, cursor: String) {
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
        self.access_token = plaidItemAccessToken
        self.cursor = cursor
        // TODO: This is possibly invalid and should be revisited in the future.
        self.count = 500
    }
}
