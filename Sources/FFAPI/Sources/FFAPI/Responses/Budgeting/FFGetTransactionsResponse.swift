//
//  FFGetTransactionsResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/14/23.
//

import Foundation

public struct FFGetTransactionsResponse: Codable {
    public let transactions: [FFTransaction]
    
    public init(transactions: [FFTransaction]) {
        self.transactions = transactions
    }
}
