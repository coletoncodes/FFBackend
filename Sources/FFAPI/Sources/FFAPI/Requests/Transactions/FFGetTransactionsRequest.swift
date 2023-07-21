//
//  FFGetTransactionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

public struct FFGetTransactionsRequest: FFAPIRequest {
    typealias Response = FFGetTransactionsResponse
    
    var body: Encodable? = nil
    
    var method: HTTPMethod {
        .GET
    }
    
    var path: String {
        "\(FFAPIPath.transactions)" + "/" + "\(budgetItemID)"
    }
    
    var headers: [FFAPIHeader] {
        FFAPIHeader.apiHeaders(refreshToken: refreshToken, accessToken: accessToken)
    }
    
    let accessToken: FFAccessToken
    let refreshToken: FFRefreshToken
    let budgetItemID: UUID
    
    init(
        budgetItemID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.budgetItemID = budgetItemID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct FFGetTransactionsResponse: Codable {
    public let transactions: [FFTransaction]
    
    public init(transactions: [FFTransaction]) {
        self.transactions = transactions
    }
}
