//
//  FFPostBudgetItemsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

struct FFPostBudgetItemsRequest: FFAPIRequest {
    typealias Response = [FFBudgetItem]
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String {
        FFAPIPath.budgetCategories
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    
    // MARK: - Initializer
    init(
        body: FFPostBudgetItemsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFPostBudgetItemsRequestBody: Codable {
    public let budgetItems: [FFBudgetItem]
    public let categoryID: UUID
    
    public init(
        budgetItems: [FFBudgetItem],
        categoryID: UUID
    ) {
        self.budgetItems = budgetItems
        self.categoryID = categoryID
    }
}
