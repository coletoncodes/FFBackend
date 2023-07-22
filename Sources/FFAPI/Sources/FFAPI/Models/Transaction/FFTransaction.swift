//
//  FFTransaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFTransaction: Codable, Hashable, Equatable {
    public let name: String
    public let budgetItemID: UUID
    public let amount: Double
    public let date: Date
    public let transactionType: FFTransactionType
    
    public init(
        name: String,
        budgetItemID: UUID,
        amount: Double,
        date: Date,
        transactionType: FFTransactionType
    ) {
        self.name = name
        self.budgetItemID = budgetItemID
        self.amount = amount
        self.date = date
        self.transactionType = transactionType
    }
}
