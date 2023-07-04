//
//  FFGetInstitutionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFGetInstitutionsRequest: FFAPIRequest {
    typealias Response = [FFInstitution]
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        return FFAPIPath.getInstitutions(userID)
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
    public let userID: UUID
    
    public init(
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken,
        userID: UUID
    ) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.userID = userID
    }
    
}
