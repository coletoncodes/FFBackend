//
//  FFPostBudgetItemRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import Foundation

struct FFPostBudgetItemRequest: FFAPIRequest {
    typealias Response = FFBudgetItemResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .POST
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

public struct FFBudgetItemResponse: Codable {
    public let budgetItem: FFBudgetItem
    
    public init(budgetItem: FFBudgetItem) {
        self.budgetItem = budgetItem
    }
}

public struct FFBudgetItemRequestBody: Codable {
    public let budgetItem: FFBudgetItem
    
    public init(
        budgetItem: FFBudgetItem
    ) {
        self.budgetItem = budgetItem
    }
}
