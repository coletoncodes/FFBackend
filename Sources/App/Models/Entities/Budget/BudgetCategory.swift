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
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "category_type")
    var type: CategoryType

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        userID: UUID,
        type: CategoryType
    ) {
        self.id = id
        self.name = name
        self.$user.id = userID
        self.type = type
    }
    
    convenience init(from category: FFBudgetCategory) {
        self.init(
            id: category.id,
            name: category.name,
            userID: category.userID,
            type: CategoryType(from: category.type)
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
