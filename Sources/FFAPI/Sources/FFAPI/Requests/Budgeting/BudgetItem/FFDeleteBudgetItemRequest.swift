//
//  FFDeleteBudgetItemRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import Foundation

struct FFDeleteBudgetItemRequest: FFAPIRequest {
    typealias Response = FFBudgetItemResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .DELETE
    }
    
    var path: String {
        FFAPIPath.budgetItems
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    
    init(
        body: FFBudgetItemRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
