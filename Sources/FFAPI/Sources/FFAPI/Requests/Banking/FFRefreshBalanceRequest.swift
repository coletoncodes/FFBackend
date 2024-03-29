//
//  FFRefreshBalanceRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/5/23.
//

import Foundation

struct FFRefreshBalanceRequest: FFAPIRequest {
    typealias Response = FFRefreshBalanceResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        "\(FFAPIPath.institutions)" + "balance"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    
    init(
        body: FFRefreshBalanceRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
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

public struct FFRefreshBalanceResponse: Codable {
    public let institution: FFInstitution
    
    public init(institution: FFInstitution) {
        self.institution = institution
    }
}
