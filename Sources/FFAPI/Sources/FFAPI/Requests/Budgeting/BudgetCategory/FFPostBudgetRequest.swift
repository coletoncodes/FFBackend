//
//  FFPostBudgetRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

struct FFPostBudgetRequest: FFAPIRequest {
    typealias Response = FFBudgetResponse
    
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
        body: FFPostBudgetRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.body = body
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct FFPostBudgetRequestBody: Codable {
    public let budgetCategories: [FFBudgetCategory]
    public let userID: UUID
    
    public init(
        budgetCategories: [FFBudgetCategory],
        userID: UUID
    ) {
        self.budgetCategories = budgetCategories
        self.userID = userID
    }
}
