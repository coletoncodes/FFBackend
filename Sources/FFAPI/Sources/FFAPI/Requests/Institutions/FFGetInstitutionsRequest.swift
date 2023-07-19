//
//  FFGetInstitutionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

struct FFGetInstitutionsRequest: FFAPIRequest {
    typealias Response = FFGetInstitutionsResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        return FFAPIPath.getInstitutions
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    
    init(
        body: FFGetInstitutionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFGetInstitutionsRequestBody: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}

public struct FFGetInstitutionsResponse: Codable {
    public let institutions: [FFInstitution]
    
    public init(institutions: [FFInstitution]) {
        self.institutions = institutions
    }
}
