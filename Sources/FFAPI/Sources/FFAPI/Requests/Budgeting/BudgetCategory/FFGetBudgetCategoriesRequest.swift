//
//  FFGetBudgetCategoriesRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

struct FFGetBudgetCategoriesRequest: FFAPIRequest {
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let monthlyBudgetID: UUID
    
    // MARK: - Initializer
    init(
        monthlyBudgetID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.monthlyBudgetID = monthlyBudgetID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFBudgetCategoriesResponse
    
    var body: Encodable?
    
    var path: String {
        "\(FFAPIPath.budgetCategories)" + "\(monthlyBudgetID)"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
}
