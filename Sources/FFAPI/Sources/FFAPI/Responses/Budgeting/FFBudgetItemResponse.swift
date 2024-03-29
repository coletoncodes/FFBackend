//
//  FFBudgetItemResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

public struct FFBudgetItemResponse: Codable {
    public let budgetItem: FFBudgetItem
    
    public init(budgetItem: FFBudgetItem) {
        self.budgetItem = budgetItem
    }
}
