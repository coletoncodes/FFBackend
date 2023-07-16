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
    public let budgetItemID: UUID
    public let amount: Double
    public let roundedDate: RoundedDate
    public let transactionType: FFTransactionType
    
    public init(
        id: UUID?,
        name: String,
        budgetItemID: UUID,
        amount: Double,
        roundedDate: RoundedDate,
        transactionType: FFTransactionType
    ) {
        self.id = id
        self.name = name
        self.budgetItemID = budgetItemID
        self.amount = amount
        self.roundedDate = roundedDate
        self.transactionType = transactionType
    }
}

// TODO: move to new file
public struct RoundedDate: Codable, Hashable, Equatable {
    public let date: Date
    
    public init(_ date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.date = calendar.date(from: components) ?? date
    }
    
    public static func ==(lhs: RoundedDate, rhs: RoundedDate) -> Bool {
        return lhs.date == rhs.date
    }
}
