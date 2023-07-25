//
//  BudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/24/23.
//

import Foundation
import Fluent
import FFAPI

final class BudgetItem: Model {
    static let schema = "budget_items"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "budget_category_id")
    var category: BudgetCategory
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "planned")
    var planned: Double
    
    @OptionalField(key: "due_date")
    var dueDate: Date?

    init() {}

    init(
        id: UUID? = nil,
        budgetCategoryID: UUID,
        name: String,
        planned: Double,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.$category.id = budgetCategoryID
        self.name = name
        self.planned = planned
        self.dueDate = dueDate
    }

    convenience init(from item: FFBudgetItem) throws {
        self.init(
            id: item.id,
            budgetCategoryID: item.budgetCategoryID,
            name: item.name,
            planned: item.planned,
            dueDate: item.dueDate
        )
    }
}
