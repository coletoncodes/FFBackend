//
//  FFSession.swift
//  
//
//  Created by Coleton Gorecke on 7/3/23.
//

import Foundation

public struct FFSession: Codable, Equatable, Hashable {
    public let accessToken: FFAccessToken
    public let refreshToken: FFRefreshToken
    
    public init(
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
