//
//  User.swift
//  
//
//  Created by Coleton Gorecke on 5/13/23.
//

import Crypto
import Fluent
import Vapor

final class User: Model, Content, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() { }
    
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
    
    convenience init(from userDTO: UserDTO) throws {
        self.init(
            id: userDTO.id,
            firstName: userDTO.firstName,
            lastName: userDTO.lastName,
            email: userDTO.email,
            passwordHash: userDTO.passwordHash
        )
    }
}
