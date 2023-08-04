//
//  Institution.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Fluent
import FFAPI
import Vapor

final class Institution: Model {
    static let schema = "institutions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "access_token_id")
    var accessToken: PlaidAccessToken
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$institution)
    var accounts: [BankAccount]
    
    @Field(key: "plaid_item_id")
    var plaidItemID: String

    init() { }

    init(
        id: UUID? = nil,
        accessTokenID: UUID,
        userID: UUID,
        plaidItemID: String,
        name: String
    ) {
        self.id = id
        self.name = name
        self.$accessToken.id = accessTokenID
        self.plaidItemID = plaidItemID
        self.$user.id = userID
    }
}
