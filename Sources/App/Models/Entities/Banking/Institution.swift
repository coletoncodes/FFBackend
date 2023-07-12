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
    
    @Field(key: "item_id")
    var itemID: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        accessTokenID: UUID,
        itemID: String,
        userID: UUID
    ) {
        self.id = id
        self.name = name
        self.$accessToken.id = accessTokenID
        self.itemID = itemID
        self.$user.id = userID
    }
}