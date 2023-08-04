//
//  FFInstitution.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFInstitution: Codable, Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let userID: UUID
    public let plaidItemID: String
    public let plaidAccessTokenID: UUID
    public var accounts: [FFBankAccount]
    
    public init(
        id: UUID,
        name: String,
        userID: UUID,
        plaidItemID: String,
        plaidAccessTokenID: UUID,
        accounts: [FFBankAccount]
    ) {
        self.id = id
        self.name = name
        self.userID = userID
        self.plaidItemID = plaidItemID
        self.plaidAccessTokenID = plaidAccessTokenID
        self.accounts = accounts
    }
}
