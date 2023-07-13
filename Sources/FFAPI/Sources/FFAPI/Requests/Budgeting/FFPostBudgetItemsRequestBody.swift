//
//  FFPostBudgetItemsRequestBody.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

public struct FFPostBudgetItemsRequestBody: Codable {
    public let budgetItems: [FFBudgetItem]
    public let categoryID: UUID
    
    public init(
        budgetItems: [FFBudgetItem],
        categoryID: UUID
    ) {
        self.budgetItems = budgetItems
        self.categoryID = categoryID
    }
}
