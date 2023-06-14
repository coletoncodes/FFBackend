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

    @Siblings(through: InstitutionAccount.self, from: \.$institution, to: \.$account)
    var accounts: [Account]

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "access_token_id")
    var accessToken: PlaidAccessToken

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        accounts: [Account],
        userID: UUID,
        accessTokenID: UUID
    ) {
        self.id = id
        self.name = name
        self.accounts = accounts
        self.$user.id = userID
        self.$accessToken.id = accessTokenID
    }
}

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

    init() {}
}

final class InstitutionAccount: Model {
    static let schema = "institution_accounts"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "institution_id")
    var institution: Institution

    @Parent(key: "account_id")
    var account: Account

    init() { }

    init(
        id: UUID? = nil,
        institutionID: UUID,
        accountID: UUID
    ) {
        self.id = id
        self.$institution.id = institutionID
        self.$account.id = accountID
    }
}

