//
//  FFBudgetItemsResponse.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

import Foundation

public struct FFBudgetItemsResponse: Codable {
    public let budgetItems: [FFBudgetItem]
    
    public init(budgetItems: [FFBudgetItem]) {
        self.budgetItems = budgetItems
    }
}
