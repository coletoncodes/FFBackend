//
//  FFBankAccount.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import Foundation

public struct FFBankAccount: Codable {
    public let id: UUID?
    public let accountID: String
    public let name: String
    public let subtype: String
    public let institutionID: UUID?
    public let userID: UUID?
    public var isSyncingTransactions: Bool
    
    public init(
        id: UUID?,
        accountID: String,
        name: String,
        subtype: String,
        institutionID: UUID,
        userID: UUID,
        isSyncingTransactions: Bool
    ) {
        self.id = id
        self.accountID = accountID
        self.name = name
        self.subtype = subtype
        self.institutionID = institutionID
        self.userID = userID
        self.isSyncingTransactions = isSyncingTransactions
    }
}
