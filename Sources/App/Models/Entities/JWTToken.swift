//
//  JWTToken.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

import Fluent
import Vapor

final class JWTToken: Model, Content {
    static let schema = "jwt_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "expires_at", on: .update)
    var expiresAt: Date?
    
    init() { }
    
    init(
        id: UUID? = nil,
        token: String,
        userId: User.IDValue,
        expiresAt: Date?
    ) {
        self.id = id
        self.token = token
        self.$user.id = userId
        self.expiresAt = expiresAt
    }
}
