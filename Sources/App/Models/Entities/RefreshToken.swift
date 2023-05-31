//
//  RefreshToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Fluent
import Vapor

final class RefreshToken: Model, Content {
    static let schema = "refresh_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "token")
    var token: String

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "expires_at", on: .update)
    var expiresAt: Date?

    init() { }

    init(
        id: UUID? = nil,
        userID: UUID,
        token: String,
        expiresAt: Date?
    ) {
        self.id = id
        self.$user.id = userID
        self.token = token
        self.expiresAt = expiresAt
    }
}
