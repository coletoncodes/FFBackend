//
//  FFMonthlyBudgetResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

public struct FFMonthlyBudgetResponse: Codable {
    public let monthlyBudget: FFMonthlyBudget
    
    public init(monthlyBudget: FFMonthlyBudget) {
        self.monthlyBudget = monthlyBudget
    }
}
