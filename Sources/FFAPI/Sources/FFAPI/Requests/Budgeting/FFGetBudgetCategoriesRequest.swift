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
    typealias Response = [FFBudgetCategory]
    
    var body: Encodable?
    
    var path: String {
        FFAPIPath.getBudgetCategories
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var headers: [FFAPIHeader] {
        var authHeaders = FFAPIHeader.auth(refreshToken: refreshToken.token, accessToken: accessToken.token)
        authHeaders.append(FFAPIHeader.contentType
        )
        return authHeaders
    }
}

public struct FFGetBudgetCategoriesRequestBody: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
