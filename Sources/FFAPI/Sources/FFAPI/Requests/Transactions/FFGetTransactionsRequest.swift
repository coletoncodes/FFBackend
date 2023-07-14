//
//  FFGetTransactionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

public struct FFGetTransactionsRequest: FFAPIRequest {
    typealias Response = FFGetTransactionsResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .GET
    }
    
    var path: String {
        FFAPIPath.transactions
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    
    init(
        body: FFGetTransactionsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct FFGetTransactionsRequestBody: Codable {
    public let budgetItemID: UUID
    
    public init(budgetItemID: UUID) {
        self.budgetItemID = budgetItemID
    }
}

public struct FFGetTransactionsResponse: Codable {
    public let transactions: [FFTransaction]
    
    public init(transactions: [FFTransaction]) {
        self.transactions = transactions
    }
}
