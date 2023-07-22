//
//  FFBudgetResponse.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

public struct FFBudgetResponse: Codable {
    public let budgetCategories: [FFBudgetCategory]
    
    public init(budgetCategories: [FFBudgetCategory]) {
        self.budgetCategories = budgetCategories
    }
}
