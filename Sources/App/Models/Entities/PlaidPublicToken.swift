//
//  PlaidPublicToken.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Vapor
import Fluent

final class PlaidPublicToken: Model {
    static let schema = "plaid_public_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "link_token")
    var linkToken: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(
        id: UUID? = nil,
        userID: UUID,
        linkToken: String
    ) {
        self.id = id
        self.$user.id = userID
        self.linkToken = linkToken
    }
}
