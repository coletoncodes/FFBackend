//
//  BudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Fluent
import Foundation

final class BudgetItem: Model {
    static let schema = "budget_items"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Parent(key: "budget_category_id")
    var budgetCategory: BudgetCategory
    
    @Field(key: "planned")
    var planned: Double
    
    @Field(key: "note")
    var note: String
    
    @OptionalField(key: "due_date")
    var dueDate: Date?
    
    @Children(for: \.$budgetItem)
    var transactions: [Transaction]
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        budgetCategoryID: UUID,
        planned: Double,
        note: String,
        dueDate: Date?
    ) {
        self.id = id
        self.name = name
        self.$budgetCategory.id = budgetCategoryID
        self.planned = planned
        self.note = note
        self.dueDate = dueDate
    }
    
    convenience init(from item: FFBudgetItem) {
        self.init(
            id: item.id,
            name: item.name,
            budgetCategoryID: item.budgetCategoryID,
            planned: item.planned,
            note: item.note,
            dueDate: item.dueDate
        )
    }
}

