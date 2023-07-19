//
//  Institution.swift
//  
//
//  Created by Coleton Gorecke on 6/13/23.
//

import Fluent
import Vapor

final class Institution: Model {
    static let schema = "institutions"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Parent(key: "access_token_id")
    var accessToken: PlaidAccessToken
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$institution)
    var accounts: [BankAccount]
    
    @Field(key: "plaid_item_id")
    var plaidItemID: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        accessTokenID: UUID,
        plaidItemID: String,
        userID: UUID
    ) {
        self.id = id
        self.name = name
        self.$accessToken.id = accessTokenID
        self.plaidItemID = plaidItemID
        self.$user.id = userID
    }
}
