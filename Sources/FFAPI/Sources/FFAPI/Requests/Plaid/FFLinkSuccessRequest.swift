//
//  FFLinkSuccessRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

struct FFLinkSuccessRequest: FFAPIRequest {
    typealias Response = FFCreateLinkTokenResponse
    
    var body: Encodable?
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.linkSuccess
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    
    init(
        body: FFLinkSuccessRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
