//
//  FFPostMonthlyBudgetRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

struct FFPostMonthlyBudgetRequest: FFAPIRequest {
    typealias Response = FFMonthlyBudgetResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String {
        FFAPIPath.monthlyBudget
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    
    init(
        body: FFPostMonthlyBudgetRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct FFPostMonthlyBudgetRequestBody: Codable {
    public let monthlyBudget: FFMonthlyBudget
    
    public init(monthlyBudget: FFMonthlyBudget) {
        self.monthlyBudget = monthlyBudget
    }
}
