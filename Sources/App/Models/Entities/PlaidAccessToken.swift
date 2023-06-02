//
//  PlaidAccessToken.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Vapor
import Fluent

final class PlaidAccessToken: Model {
    static let schema = "plaid_access_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "access_token")
    var accessToken: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(
        id: UUID? = nil,
        userID: UUID,
        accessToken: String
    ) {
        self.id = id
        self.$user.id = userID
        self.accessToken = accessToken
    }
}
