//
//  Transaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import FFAPI
import Fluent

final class Transaction: Model {
    static var schema: String = "transactions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Parent(key: "budget_item_id")
    var budgetItem: BudgetItem
    
    @Field(key: "amount")
    var amount: Double
    
    @Field(key: "date_string")
    var dateString: String
        
    init() { }
    
    init(
        id: UUID? = nil,
        name: String,
        budgetItemID: UUID,
        amount: Double,
        dateString: String
    ) {
        self.id = id
        self.name = name
        self.$budgetItem.id = budgetItemID
        self.amount = amount
        self.dateString = dateString
    }
    
    convenience init(from transaction: FFTransaction) {
        self.init(
            name: transaction.name,
            budgetItemID: transaction.budgetItemID,
            amount: transaction.amount,
            dateString: CustomDateFormatter.toRoundedString(from: transaction.date)
        )
    }
}
