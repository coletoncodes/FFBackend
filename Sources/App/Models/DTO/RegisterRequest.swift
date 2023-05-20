//
//  RegisterRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

struct RegisterRequest: Content {
    let fullName: String
    let email: String
    let password: String
    let confirmPassword: String
}

extension RegisterRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("fullName", as: String.self, is: .count(3...))
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    struct Register: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Register: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("first_name", as: String.self, is: !.empty)
        validations.add("last_name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
