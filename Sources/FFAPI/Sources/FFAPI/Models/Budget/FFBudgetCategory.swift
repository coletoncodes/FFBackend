//
//  FFBudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetCategory: Codable, Hashable, Equatable {
    public let id: UUID
    public let userID: UUID
    public let name: String
    public let budgetItems: [FFBudgetItem]
    
    public init(
        id: UUID,
        userID: UUID,
        name: String,
        budgetItems: [FFBudgetItem] = []
    ) {
        self.id = id
        self.userID = userID
        self.name = name
        self.budgetItems = budgetItems
    }
}
