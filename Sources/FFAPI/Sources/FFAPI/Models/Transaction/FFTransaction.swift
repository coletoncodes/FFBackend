//
//  FFTransaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFTransaction: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID?
    public let name: String
    public let amount: Double
    public let date: Date
    public let transactionType: FFTransactionType
    
    public init(
        id: UUID?,
        name: String,
        amount: Double,
        date: Date,
        transactionType: FFTransactionType
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.transactionType = transactionType
    }
}
