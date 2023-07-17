//
//  FFExchangePublicTokenRequestBody.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Foundation

/// The Request object Client applications must provide to get an access token for a linked item.
public struct FFExchangePublicTokenRequestBody: Codable {
    public let userID: UUID
    public let publicToken: String
    
    public init(userID: UUID, publicToken: String) {
        self.userID = userID
        self.publicToken = publicToken
    }
}
