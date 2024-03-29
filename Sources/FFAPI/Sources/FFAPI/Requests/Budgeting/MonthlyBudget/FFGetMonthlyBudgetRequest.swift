//
//  FFGetMonthlyBudgetRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

struct FFGetMonthlyBudgetRequest: FFAPIRequest {
    typealias Response = FFMonthlyBudgetResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod {
        .GET
    }
    
    var path: String {
        FFAPIPath.monthlyBudget + "\(monthlyBudgetID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    let monthlyBudgetID: UUID
    
    init(
        monthlyBudgetID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.monthlyBudgetID = monthlyBudgetID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
