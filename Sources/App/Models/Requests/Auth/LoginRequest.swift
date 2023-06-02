//
//  LoginRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}

extension LoginRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
