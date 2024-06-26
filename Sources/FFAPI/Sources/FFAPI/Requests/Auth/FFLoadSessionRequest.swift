//
//  FFLoadSessionRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

struct FFLoadSessionRequest: FFAPIRequest {
    typealias Response = FFSessionResponse
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.loadSession
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    var body: Encodable? = nil
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
}
