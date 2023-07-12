//
//  FFBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetCategory: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID
    public let name: String
    public let budgetItems: [FFBudgetItem]
    public let categoryType: FFBudgetCategoryType
    
    public init(
        id: UUID,
        name: String,
        budgetItems: [FFBudgetItem],
        categoryType: FFBudgetCategoryType
    ) {
        self.id = id
        self.name = name
        self.budgetItems = budgetItems
        self.categoryType = categoryType
    }
}
