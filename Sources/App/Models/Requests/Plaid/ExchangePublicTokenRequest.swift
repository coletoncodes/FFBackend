//
//  ExchangePublicTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Foundation
import Vapor

/// The Request object Client applications must provide to get an access token for a linked item.
struct ExchangePublicTokenRequest: Content {
    let userID: UUID
    let publicToken: String
    
    init(userID: UUID, publicToken: String) {
        self.userID = userID
        self.publicToken = publicToken
    }
}
