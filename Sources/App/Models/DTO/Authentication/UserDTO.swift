//
//  UserDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

/// The User Data Transfer Object.
///
/// Used to pass user data between different parts of the application or across network boundaries.
struct UserDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let passwordHash: String
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        email: String,
        passwordHash: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
    }
    
    init(from user: User) {
        self.init(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            passwordHash: user.passwordHash
        )
    }
}
