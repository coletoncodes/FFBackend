//
//  CreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Vapor

/// Initiates the CreateLinkToken API.
struct CreateLinkTokenRequest: Content {
    let userID: UUID
}
