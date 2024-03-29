//
//  FFLoginRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Foundation

struct LoginUserRequest: FFAPIRequest {
    typealias Response = FFSessionResponse
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.loginUser
    }
    
    var headers: [FFAPIHeader] {
        [FFAPIHeader.contentType]
    }
    
    var body: Encodable?
    
    init(body: FFLoginRequest) {
        self.body = body
    }
}

public struct FFLoginRequest: Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
