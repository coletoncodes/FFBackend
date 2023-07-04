//
//  FFCreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Foundation

public struct FFCreateLinkTokenRequest: FFAPIRequest {
    public typealias Response = FFCreateLinkTokenResponse
    
    public var body: Encodable?
    
    var method: HTTPMethod { .POST }
    
    public var path: String {
        FFAPIPath.createLinkToken
    }
    
    var headers: [FFAPIHeader] {
        [
            FFAPIHeader.contentType,
            FFAPIHeader.auth(refreshToken: refreshToken.token),
            FFAPIHeader.apiAuth(accessToken: accessToken.token)
        ]
    }
    
    public let refreshToken: FFRefreshToken
    public let accessToken: FFAccessToken
    
    public init(
        body: FFCreateLinkTokenRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

/// Initiates the CreateLinkToken API.
public struct FFCreateLinkTokenRequestBody: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
