//
//  BankAccount.swift
//  
//
//  Created by Coleton Gorecke on 8/3/23.
//

import Foundation
import Fluent

final class BankAccount: Model {
    static let schema = "bank_accounts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "institution_id")
    var institution: Institution
    
    @Field(key: "account_id")
    var accountID: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "subtype")
    var subtype: String
    
    @Boolean(key: "is_syncing_transactions")
    var isSyncingTransactions: Bool
    
    @Field(key: "current_balance")
    var currentBalance: Double
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        institutionID: String,
        accountID: String,
        name: String,
        subtype: String,
        isSyncingTransactions: Bool,
        currentBalance: Double
    ) {
        self.id = id
        self.$user.id = userID
        self.institution.plaidItemID = institutionID
        self.name = name
        self.subtype = subtype
        self.isSyncingTransactions = isSyncingTransactions
        self.currentBalance = currentBalance
    }
}
