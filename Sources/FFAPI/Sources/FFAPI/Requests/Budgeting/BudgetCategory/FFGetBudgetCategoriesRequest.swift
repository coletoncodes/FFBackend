//
//  FFGetBudgetRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

struct FFGetBudgetCategoriesRequest: FFAPIRequest {
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let userID: UUID
    
    // MARK: - Initializer
    init(
        userID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.userID = userID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFBudgetCategoriesResponse
    
    var body: Encodable?
    
    var path: String {
        "\(FFAPIPath.budgetCategories)" + "/" + "\(userID)"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
}
