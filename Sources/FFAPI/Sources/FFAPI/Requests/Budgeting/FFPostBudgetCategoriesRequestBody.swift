//
//  FFPostBudgetCategoriesRequestBody.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

public struct FFPostBudgetCategoriesRequestBody: Codable {
    public let budgetCategories: [FFBudgetCategory]
    public let userID: UUID
    
    public init(
        budgetCategories: [FFBudgetCategory],
        userID: UUID
    ) {
        self.budgetCategories = budgetCategories
        self.userID = userID
    }
}
