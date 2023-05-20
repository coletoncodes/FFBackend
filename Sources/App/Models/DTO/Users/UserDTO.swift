//
//  UserDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

struct UserDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        email: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    init(from user: User) {
        self.init(id: user.id, firstName: user.firstName, lastName: user.lastName, email: user.email)
    }
}
