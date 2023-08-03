//
//  FFBankAccount.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import Foundation

public struct FFBankAccount: Codable, Equatable, Hashable {
    public let accountID: String
    public let name: String
    public let subtype: String
    public let institutionID: String
    public let userID: UUID
    public var isSyncingTransactions: Bool
    public let currentBalance: Double
    
    public init(
        accountID: String,
        name: String,
        subtype: String,
        institutionID: String,
        userID: UUID,
        isSyncingTransactions: Bool,
        currentBalance: Double
    ) {
        self.accountID = accountID
        self.name = name
        self.subtype = subtype
        self.institutionID = institutionID
        self.userID = userID
        self.isSyncingTransactions = isSyncingTransactions
        self.currentBalance = currentBalance
    }
}
