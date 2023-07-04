//
//  FFRefreshToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Foundation

public struct FFRefreshToken: Codable {
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

// TODO: Move to FFBackend
//init(from refreshToken: RefreshToken) {
//    self.init(userID: refreshToken.$user.id, token: refreshToken.token)
//}
