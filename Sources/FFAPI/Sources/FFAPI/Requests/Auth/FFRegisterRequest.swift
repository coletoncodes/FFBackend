//
//  FFRegisterRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Foundation

struct RegisterUserRequest: FFAPIRequest {
    typealias Response = FFSessionResponse
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.registerUser
    }
    
    var headers: [FFAPIHeader] {
        [FFAPIHeader.contentType]
    }
    
    var body: Encodable?
    
    init(body: FFRegisterRequest) {
        self.body = body
    }
}


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
