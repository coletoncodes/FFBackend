//
//  MonthlyBudget.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Fluent
import Foundation
import FFAPI

final class MonthlyBudget: Model {
    static let schema = "monthly_budgets"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "month")
    var month: Int

    @Field(key: "year")
    var year: Int

    @Children(for: \.$monthlyBudget)
    var categories: [BudgetCategory]
    
    @Parent(key: "user_id")
    var user: User

    init() {}

    init(
        id: UUID? = nil,
        month: Int,
        year: Int,
        userID: UUID
    ) {
        self.id = id
        self.month = month
        self.year = year
        self.$user.id = userID
    }
    
    convenience init(from ffMonthlyBudget: FFMonthlyBudget) {
        self.init(
            id: ffMonthlyBudget.id,
            month: ffMonthlyBudget.month,
            year: ffMonthlyBudget.year,
            userID: ffMonthlyBudget.userID
        )
    }
}
