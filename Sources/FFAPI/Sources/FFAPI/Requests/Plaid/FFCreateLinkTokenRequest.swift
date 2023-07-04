//
//  FFCreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Foundation

/// Initiates the CreateLinkToken API.
public struct FFCreateLinkTokenRequest: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
