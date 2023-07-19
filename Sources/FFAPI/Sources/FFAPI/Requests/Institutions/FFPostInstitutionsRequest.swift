//
//  FFPostInstitutionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/18/23.
//

import Foundation

struct FFPostInstitutionsRequest: FFAPIRequest {
    typealias Response = FFPostInstitutionsResponse
    
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
        body: FFPostInstitutionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFPostInstitutionsRequestBody: Codable {
    public let userID: UUID
    public let institutions: [FFInstitution]
    
    public init(userID: UUID, institutions: [FFInstitution]) {
        self.userID = userID
        self.institutions = institutions
    }
}

public struct FFPostInstitutionsResponse: Codable {
    public let institutions: [FFInstitution]
    
    public init(institutions: [FFInstitution]) {
        self.institutions = institutions
    }
}
