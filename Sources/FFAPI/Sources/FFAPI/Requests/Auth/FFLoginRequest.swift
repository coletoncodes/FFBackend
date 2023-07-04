//
//  FFLoginRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Foundation

public struct FFLoginRequest: Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
