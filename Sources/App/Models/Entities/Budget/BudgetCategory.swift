//
//  BudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Fluent
import Foundation

final class BudgetCategory: Model {
    static let schema = "budget_categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Children(for: \.$category)
    var budgetItems: [BudgetItem]
    
    @Parent(key: "monthly_budget_id")
    var monthlyBudget: MonthlyBudget
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        monthlyBudgetID: UUID
    ) {
        self.id = id
        self.name = name
        self.$monthlyBudget.id = monthlyBudgetID
    }
    
    convenience init(from category: FFBudgetCategory) {
        self.init(
            id: category.id,
            name: category.name,
            monthlyBudgetID: category.monthlyBudgetID
        )
    }
}
