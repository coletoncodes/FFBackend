//
//  FFBudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetItem: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID
    public let name: String
    public let planned: Double
    public let transactions: [FFTransaction]
    public let note: String
    public let dueDate: Date
    
    public init(
        id: UUID,
        name: String,
        planned: Double,
        transactions: [FFTransaction],
        note: String,
        dueDate: Date
    ) {
        self.id = id
        self.name = name
        self.planned = planned
        self.transactions = transactions
        self.note = note
        self.dueDate = dueDate
    }
}
