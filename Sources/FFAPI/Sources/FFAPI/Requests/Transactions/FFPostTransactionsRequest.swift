//
//  FFPostTransactionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

public struct FFPostTransactionsRequest: FFAPIRequest {
    typealias Response = FFPostTransactionsResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .POST
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
        body: FFPostTransactionsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct FFPostTransactionsRequestBody: Codable {
    public let budgetItemID: UUID
    public let transactions: [FFTransaction]
    
    public init(
        budgetItemID: UUID,
        transactions: [FFTransaction]
    ) {
        self.budgetItemID = budgetItemID
        self.transactions = transactions
    }
}

public struct FFPostTransactionsResponse: Codable {
    public let transactions: [FFTransaction]
    
    public init(transactions: [FFTransaction]) {
        self.transactions = transactions
    }
}
