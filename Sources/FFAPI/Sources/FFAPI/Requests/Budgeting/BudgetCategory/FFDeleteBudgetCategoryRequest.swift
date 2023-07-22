//
//  FFDeleteBudgetCategoryRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

struct FFDeleteBudgetCategoryRequest: FFAPIRequest {
    typealias Response = FFDeleteBudgetCategoryResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .DELETE
    }
    
    var path: String {
        FFAPIPath.budgeting
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    
    init(
        body: FFDeleteBudgetCategoryRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

struct FFDeleteBudgetCategoryResponse: Codable {}

public struct FFDeleteBudgetCategoryRequestBody: Codable {
    public let budgetCategory: FFBudgetCategory
    
    public init(budgetCategory: FFBudgetCategory) {
        self.budgetCategory = budgetCategory
    }
}
