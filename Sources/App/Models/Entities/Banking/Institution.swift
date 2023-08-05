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

    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "plaid_access_token")
    var plaidAccessToken: String
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$institution)
    var accounts: [BankAccount]
    
    init() { }

    init(
        id: UUID? = nil,
        plaidAccessToken: String,
        userID: UUID,
        name: String
    ) {
        self.id = id
        self.name = name
        self.plaidAccessToken = plaidAccessToken
        self.$user.id = userID
    }
    
    convenience init(from ffInstitution: FFInstitution) {
        self.init(
            id: ffInstitution.id,
            plaidAccessToken: ffInstitution.plaidAccessToken,
            userID: ffInstitution.userID,
            name: ffInstitution.name
        )
    }
}
