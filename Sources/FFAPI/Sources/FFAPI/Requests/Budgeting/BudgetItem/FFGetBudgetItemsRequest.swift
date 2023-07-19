//
//  FFGetBudgetItemsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

struct FFGetBudgetItemsRequest: FFAPIRequest {
    
    let refreshToken: FFRefreshToken
    let accessToken: FFAccessToken
    let categoryID: UUID
    
    // MARK: - Initializer
    init(
        categoryID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.categoryID = categoryID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFBudgetItemsResponse
    
    var body: Encodable?
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        "\(FFAPIPath.budgetItems)" + "/" + "\(categoryID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
}
