//
//  FFRefreshToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Foundation

public struct FFRefreshToken: Codable, Equatable, Hashable, Identifiable {
    public var id: String {
        token + userID.uuidString
    }
    
    public let userID: UUID
    public let token: String
    
    public init(
        userID: UUID,
        token: String
    ) {
        self.userID = userID
        self.token = token
    }
}
