//
//  FFRegisterRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Foundation

public struct FFRegisterRequest: Codable {
    public let firstName: String
    public let lastName: String
    public let email: String
    public let password: String
    public let confirmPassword: String
    
    public init(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        confirmPassword: String
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}

// TODO: Move to FFBackend
//extension RegisterRequest: Validatable {
//    /// Validates the RegisterRequest.
//    static func validations(_ validations: inout Validations) {
//        validations.add("firstName", as: String.self, is: !.empty)
//        validations.add("lastName", as: String.self, is: !.empty)
//        validations.add("email", as: String.self, is: .email)
//        validations.add("password", as: String.self, is: .count(8...))
//        validations.add("confirmPassword", as: String.self, is: .count(8...))
//    }
//}

// TODO: Move to FFBackend
//extension User {
//    /// Creates a new user from a `RegisterRequest` and encrypts the password.
//    /// - Parameters:
//    ///   - request: The registration request sent in the body.
//    convenience init(from request: RegisterRequest) throws {
//        self.init(
//            firstName: request.firstName,
//            lastName: request.lastName,
//            email: request.email,
//            passwordHash: try Bcrypt.hash(request.password)
//        )
//    }
//}
