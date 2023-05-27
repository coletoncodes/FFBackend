//
//  SessionResponse.swift
//  
//
//  Created by Coleton Gorecke on 5/27/23.
//

import Vapor

struct SessionResponse: Content {
    let user: UserDTO
    let session: SessionDTO
}
