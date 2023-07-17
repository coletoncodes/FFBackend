//
//  BudgetCategoryType.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Fluent
import Foundation

public enum BudgetCategoryType: String, Codable {
    case savings
    case income
    case expense
    
    init(from type: FFBudgetCategoryType) {
        switch type {
        case .expense:
            self = .expense
        case .income:
            self = .income
        case .savings:
            self = .savings
        }
    }
}
