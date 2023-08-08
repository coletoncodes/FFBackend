//
//  FFBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetCategory: Codable, Hashable, Equatable {
    public let id: UUID
    public let monthlyBudgetID: UUID
    public let name: String
    public let budgetItems: [FFBudgetItem]
    
    public init(
        id: UUID,
        monthlyBudgetID: UUID,
        name: String,
        budgetItems: [FFBudgetItem] = []
    ) {
        self.id = id
        self.monthlyBudgetID = monthlyBudgetID
        self.name = name
        self.budgetItems = budgetItems
    }
}
