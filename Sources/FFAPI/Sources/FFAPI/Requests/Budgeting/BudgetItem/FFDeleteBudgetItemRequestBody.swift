//
//  FFDeleteBudgetItemRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

struct FFDeleteBudgetItemRequest: FFAPIRequest {
    typealias Response = FFDeleteBudgetItemResponse
    
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
        body: FFDeleteBudgetItemRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

struct FFDeleteBudgetItemResponse: Codable {}

public struct FFDeleteBudgetItemRequestBody: Codable {
    public let budgetItem: FFBudgetItem
    
    public init(budgetItem: FFBudgetItem) {
        self.budgetItem = budgetItem
    }
}
