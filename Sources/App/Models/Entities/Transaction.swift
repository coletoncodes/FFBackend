//
//  Transaction.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Fluent
import FFAPI
import Vapor

final class Transaction: Model {
    static let schema = "transactions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "bank_account_id")
    var bankAccount: BankAccount
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "amount")
    var amount: Double
    
    init() { }

    init(
        id: UUID? = nil,
        bankAccountID: UUID,
        name: String,
        date: Date,
        amount: Double
    ) {
        self.id = id
        self.$bankAccount.id = bankAccountID
        self.name = name
        self.date = date
        self.amount = amount
    }
    
    convenience init(from ffTransaction: FFTransaction) {
        self.init(
            id: ffTransaction.id,
            bankAccountID: ffTransaction.bankAccountID,
            name: ffTransaction.name,
            date: ffTransaction.date,
            amount: ffTransaction.amount
        )
    }
}
