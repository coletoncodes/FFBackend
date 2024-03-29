//
//  FFPostBudgetCategoriesRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

struct FFPostBudgetCategoriesRequest: FFAPIRequest {
    typealias Response = FFBudgetCategoriesResponse
    
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
        body: FFPostBudgetCategoriesRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFPostBudgetCategoriesRequestBody: Codable {
    public let budgetCategories: [FFBudgetCategory]
    public let monthlyBudgetID: UUID
    
    public init(
        budgetCategories: [FFBudgetCategory],
        monthlyBudgetID: UUID
    ) {
        self.budgetCategories = budgetCategories
        self.monthlyBudgetID = monthlyBudgetID
    }
}
