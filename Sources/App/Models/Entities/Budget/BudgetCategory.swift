//
//  BudgetCategory.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Fluent
import Foundation

final class BudgetCategory: Model {
    static let schema = "budget_categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Children(for: \.$budgetCategory)
    var budgetItems: [BudgetItem]
    
    @Parent(key: "user_id")
    var user: User

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        userID: UUID
    ) {
        self.id = id
        self.name = name
        self.$user.id = userID
    }
}
