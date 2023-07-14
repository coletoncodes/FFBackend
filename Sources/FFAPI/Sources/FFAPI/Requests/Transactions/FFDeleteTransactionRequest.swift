//
//  FFDeleteTransactionRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

public struct FFDeleteTransactionRequest: FFAPIRequest {
    typealias Response = FFDeleteTransactionResponse
    
    var body: Encodable?
    
    var method: HTTPMethod {
        .DELETE
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
        body: FFDeleteTransactionRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.body = body
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

public struct FFDeleteTransactionRequestBody: Codable {
    public let budgetItemID: UUID
    public let transaction: FFTransaction
    
    public init(
        budgetItemID: UUID,
        transaction: FFTransaction
    ) {
        self.budgetItemID = budgetItemID
        self.transaction = transaction
    }
}

public struct FFDeleteTransactionResponse: Codable {}
