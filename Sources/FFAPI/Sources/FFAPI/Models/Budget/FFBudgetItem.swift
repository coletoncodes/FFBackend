//
//  FFBudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetItem: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID?
    public let name: String
    public let budgetCategoryID: UUID
    public let planned: Double
    public var transactions: [FFTransaction]
    public let note: String
    public let dueDate: Date?
    
    public init(
        id: UUID?,
        name: String,
        budgetCategoryID: UUID,
        planned: Double,
        transactions: [FFTransaction],
        note: String,
        dueDate: Date?
    ) {
        self.id = id
        self.name = name
        self.budgetCategoryID = budgetCategoryID
        self.planned = planned
        self.transactions = transactions
        self.note = note
        self.dueDate = dueDate
    }
}
