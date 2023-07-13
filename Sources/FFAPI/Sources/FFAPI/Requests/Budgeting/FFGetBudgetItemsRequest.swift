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
    
    // MARK: - Initializer
    init(
        body: FFGetBudgetItemsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFBudgetItemsResponse
    
    var body: Encodable?
    
    var method: HTTPMethod { .GET }
    
    var path: String { FFAPIPath.budgetItems
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
}

public struct FFGetBudgetItemsRequestBody: Codable {
    public let categoryID: UUID
    
    public init(categoryID: UUID) {
        self.categoryID = categoryID
    }
}
