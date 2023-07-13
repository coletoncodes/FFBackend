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
    
    // MARK: - Initializer
    init(
        body: FFGetBudgetCategoriesRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFBudgetCategoriesResponse
    
    var body: Encodable?
    
    var path: String {
        FFAPIPath.budgetCategories
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
}

public struct FFGetBudgetCategoriesRequestBody: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
