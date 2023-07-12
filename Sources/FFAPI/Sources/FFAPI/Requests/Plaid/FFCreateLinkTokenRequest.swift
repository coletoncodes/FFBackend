//
//  FFCreateLinkTokenRequest.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Foundation

struct FFCreateLinkTokenRequest: FFAPIRequest {
    typealias Response = FFCreateLinkTokenResponse
    
    var body: Encodable?
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.createLinkToken
    }
    
    var headers: [FFAPIHeader] {
        var authHeaders = FFAPIHeader.auth(refreshToken: refreshToken.token, accessToken: accessToken.token)
        authHeaders.append(FFAPIHeader.contentType
        )
        return authHeaders
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    
    init(
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
