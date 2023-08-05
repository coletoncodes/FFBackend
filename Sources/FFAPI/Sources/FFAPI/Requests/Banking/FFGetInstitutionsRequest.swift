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
        "\(FFAPIPath.institutions)" + "\(userID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let userID: UUID
    
    init(
        userID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.userID = userID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFGetInstitutionsResponse: Codable {
    public let institutions: [FFInstitution]
    
    public init(institutions: [FFInstitution]) {
        self.institutions = institutions
    }
}
