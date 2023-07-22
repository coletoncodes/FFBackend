//
//  FFBudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetItem: Codable, Hashable, Equatable {
    public let name: String
    public let budgetCategoryID: UUID
    public let planned: Double
    public var transactions: [FFTransaction]
    public let note: String
    public let dueDate: Date?
    
    public init(
        name: String = "",
        budgetCategoryID: UUID,
        planned: Double = 0.0,
        transactions: [FFTransaction] = [],
        note: String = "",
        dueDate: Date? = nil
    ) {
        self.name = name
        self.budgetCategoryID = budgetCategoryID
        self.planned = planned
        self.transactions = transactions
        self.note = note
        self.dueDate = dueDate
    }
}
