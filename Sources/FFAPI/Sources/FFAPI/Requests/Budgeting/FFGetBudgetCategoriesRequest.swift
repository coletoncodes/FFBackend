//
//  FFGetBudgetRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFGetBudgetCategoriesRequest: FFAPIRequest {
    
    // MARK: - Public Properties
    public let userID: UUID
    public let refreshToken: FFRefreshToken
    public let accessToken: FFAccessToken
    
    // MARK: - Initializer
    public init(
        userID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) {
        self.userID = userID
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    // MARK: - FFAPIRequest Conformance
    typealias Response = FFSessionResponse
    
    var body: Encodable? = nil
    
    var path: String {
        FFAPIPath.getBudgetCategories
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var headers: [FFAPIHeader] {
        [
            FFAPIHeader.contentType,
            FFAPIHeader.auth(refreshToken: refreshToken.token),
            FFAPIHeader.apiAuth(accessToken: accessToken.token)
        ]
    }
    
}
