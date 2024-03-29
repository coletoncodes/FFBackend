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
    
    @Field(key: "category_type")
    var type: CategoryType

    init() {}

    init(
        id: UUID? = nil,
        budgetCategoryID: UUID,
        name: String,
        planned: Double,
        type: CategoryType
    ) {
        self.id = id
        self.$category.id = budgetCategoryID
        self.name = name
        self.planned = planned
        self.type = type
    }

    convenience init(from item: FFBudgetItem) throws {
        self.init(
            id: item.id,
            budgetCategoryID: item.budgetCategoryID,
            name: item.name,
            planned: item.planned,
            type: CategoryType(from: item.type)
        )
    }
}

extension CategoryType {
    init(from type: FFCategoryType) {
        switch type {
        case .income:
            self = .income
        case .expense:
            self = .expense
        }
    }
}

