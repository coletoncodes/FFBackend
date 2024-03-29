//
//  FFDeleteBudgetCategoryRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

struct FFDeleteBudgetCategoryRequest: FFAPIRequest {
    typealias Response = FFDeleteBudgetCategoryResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod {
        .DELETE
    }
    
    var path: String {
        FFAPIPath.budgetCategories + "\(categoryID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    let categoryID: UUID
    
    init(
        categoryID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.categoryID = categoryID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

struct FFDeleteBudgetCategoryResponse: Codable {}
