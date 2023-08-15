//
//  FFGetTransactionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/14/23.
//

import Foundation

struct FFGetTransactionsRequest: FFAPIRequest {
    typealias Response = FFGetTransactionsResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        "\(FFAPIPath.transactions)" + "\(institutionID)" + "/\(plaidAccessTokenID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let institutionID: UUID
    let plaidAccessTokenID: UUID
    
    init(
        institutionID: UUID,
        plaidAccessTokenID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.institutionID = institutionID
        self.plaidAccessTokenID = plaidAccessTokenID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
