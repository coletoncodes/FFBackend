//
//  FFRefreshBalanceRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/5/23.
//

import Foundation

struct FFRefreshBalanceRequest: FFAPIRequest {
    typealias Response = FFGetInstitutionsResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        "\(FFAPIPath.institutions)" + "balance" + "\(userID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let userID: UUID
    
    init(
        userID: UUID,
        body: FFRefreshBalanceRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.userID = userID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFRefreshBalanceRequestBody: Codable {
    public let institution: FFInstitution
    
    public init(institution: FFInstitution) {
        self.institution = institution
    }
}
