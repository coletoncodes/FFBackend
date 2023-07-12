//
//  Transaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
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
    
    @Field(key: "date")
    var date: Date
    
    @Enum(key: "transaction_type")
    var transactionType: TransactionType
        
    init() { }

    init(
        id: UUID? = nil,
        name: String,
        budgetItemID: UUID,
        amount: Double,
        date: Date,
        transactionType: TransactionType
    ) {
        self.id = id
        self.name = name
        self.$budgetItem.id = budgetItemID
        self.date = date
        self.transactionType = transactionType
    }
}
