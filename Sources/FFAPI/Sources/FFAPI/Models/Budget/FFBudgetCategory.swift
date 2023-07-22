//
//  FFBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetCategory: Codable, Hashable, Equatable {
    public let categoryID: UUID
    public let userID: UUID
    public let name: String
    public var budgetItems: [FFBudgetItem]
    
    public init(
        categoryID: UUID,
        userID: UUID,
        name: String,
        budgetItems: [FFBudgetItem] = []
    ) {
        self.categoryID = categoryID
        self.userID = userID
        self.name = name
        self.budgetItems = budgetItems
    }
}
