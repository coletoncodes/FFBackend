//
//  FFAllMonthlyBudgetsResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

public struct FFAllMonthlyBudgetsResponse: Codable {
    public let monthlyBudgets: [FFMonthlyBudget]
    
    public init(monthlyBudgets: [FFMonthlyBudget]) {
        self.monthlyBudgets = monthlyBudgets
    }
}
