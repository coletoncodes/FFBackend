//
//  FFLinkSuccessRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFLinkSuccessRequest: FFAPIRequest {
    public typealias Response = FFCreateLinkTokenResponse
    
    public var body: Encodable?
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.linkSuccess
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
        body: FFLinkSuccessRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
