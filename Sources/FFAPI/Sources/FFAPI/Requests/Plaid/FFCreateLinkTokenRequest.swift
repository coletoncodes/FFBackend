//
//  FFCreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Foundation

/// Initiates the CreateLinkToken API.
struct FFCreateLinkTokenRequest: Codable {
    let userID: UUID
}
