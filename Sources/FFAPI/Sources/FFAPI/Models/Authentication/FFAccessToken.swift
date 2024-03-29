//
//  FFAccessToken.swift
//  
//
//  Created by Coleton Gorecke on 7/3/23.
//

import Foundation

public struct FFAccessToken: Codable, Equatable, Hashable, Identifiable {
    public var id: String {
        token + userID.uuidString
    }
    
    public let token: String
    public let userID: UUID
    
    public init(
        token: String,
        userID: UUID
    ) {
        self.token = token
        self.userID = userID
    }
}
