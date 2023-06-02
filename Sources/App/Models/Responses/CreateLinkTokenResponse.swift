//
//  CreateLinkTokenResponse.swift
//  
//
//  Created by Coleton Gorecke on 6/1/23.
//

import Vapor

struct CreateLinkTokenResponse: Content {
    let linkToken: String
}
