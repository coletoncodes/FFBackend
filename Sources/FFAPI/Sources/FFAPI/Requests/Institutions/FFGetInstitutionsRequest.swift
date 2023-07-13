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
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
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
