//
//  FFGetAllMonthlyBudgetsRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

struct FFGetAllMonthlyBudgetsRequest: FFAPIRequest {
    typealias Response = FFAllMonthlyBudgetsResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod {
        .GET
    }
    
    var path: String {
        FFAPIPath.monthlyBudgetAll + "\(userID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    let userID: UUID
    
    init(
        userID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.userID = userID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
