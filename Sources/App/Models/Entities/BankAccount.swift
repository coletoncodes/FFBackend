//
//  BankAccount.swift
//  
//
//  Created by Coleton Gorecke on 6/20/23.
//

import Foundation
import Fluent

final class BankAccount: Model {
    static let schema = "bank_accounts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "account_id")
    var accountID: String

    @Field(key: "name")
    var name: String

    @Field(key: "subtype")
    var subtype: String

    @Parent(key: "institution_id")
    var institution: Institution
    
    @Parent(key: "user_id")
    var user: User

    init() {}

    init(
        id: UUID? = nil,
        accountID: String,
        name: String,
        subtype: String,
        institutionID: UUID,
        userID: UUID
    ) {
        self.id = id
        self.accountID = accountID
        self.name = name
        self.subtype = subtype
        self.$institution.id = institutionID
        self.$user.id = userID
    }
}
