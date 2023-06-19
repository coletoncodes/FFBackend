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
    
    @Children(for: \.$institution)
    var accounts: [Account]
    
    @Field(key: "item_id")
    var itemID: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        accessTokenID: UUID,
        itemID: String
    ) {
        self.id = id
        self.name = name
        self.$accessToken.id = accessTokenID
        self.itemID = itemID
    }
}

// MARK: - Move to separate file
final class Account: Model {
    static let schema = "accounts"

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

    init() {}

    init(id: UUID? = nil, accountID: String, name: String, subtype: String, institutionID: UUID) {
        self.id = id
        self.accountID = accountID
        self.name = name
        self.subtype = subtype
        self.$institution.id = institutionID
    }
}
