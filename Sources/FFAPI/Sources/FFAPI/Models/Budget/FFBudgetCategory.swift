//
//  FFBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetCategory: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID?
    public let userID: UUID
    public let name: String
    public var budgetItems: [FFBudgetItem]
    public let categoryType: FFBudgetCategoryType
    
    public init(
        id: UUID?,
        userID: UUID,
        name: String,
        budgetItems: [FFBudgetItem],
        categoryType: FFBudgetCategoryType
    ) {
        self.id = id
        self.userID = userID
        self.name = name
        self.budgetItems = budgetItems
        self.categoryType = categoryType
    }
}
