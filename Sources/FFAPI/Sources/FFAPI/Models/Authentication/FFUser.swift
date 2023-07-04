//
//  FFUser.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Foundation

public struct FFUser: Codable {
    public let id: UUID?
    public let firstName: String
    public let lastName: String
    public let email: String
    public let passwordHash: String
    
    public init(
        id: UUID? = UUID(),
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
}
