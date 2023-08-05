//
//  FFInstitution.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFInstitution: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public let name: String
    public let userID: UUID
    public let plaidAccessToken: String
    public var accounts: [FFBankAccount]
    
    public init(
        id: UUID,
        name: String,
        userID: UUID,
        plaidAccessToken: String,
        accounts: [FFBankAccount]
    ) {
        self.id = id
        self.name = name
        self.userID = userID
        self.plaidAccessToken = plaidAccessToken
        self.accounts = accounts
    }
}
