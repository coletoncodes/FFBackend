//
//  FFGetInstitutionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

struct FFGetInstitutionsRequest: FFAPIRequest {
    typealias Response = [FFInstitution]
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        return FFAPIPath.getInstitutions(userID)
    }
    
    var headers: [FFAPIHeader] {
        var authHeaders = FFAPIHeader.auth(refreshToken: refreshToken.token, accessToken: accessToken.token)
        authHeaders.append(FFAPIHeader.contentType
        )
        return authHeaders
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let userID: UUID
    
    init(
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken,
        userID: UUID
    ) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.userID = userID
    }
}
