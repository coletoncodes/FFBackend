//
//  FFBankAccount.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import Foundation

public struct FFBankAccount: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public let accountID: String
    public let name: String
    public let subtype: String
    public let institutionID: UUID
    public var isSyncingTransactions: Bool
    public let currentBalance: Double
    
    public init(
        id: UUID,
        accountID: String,
        name: String,
        subtype: String,
        institutionID: UUID,
        isSyncingTransactions: Bool,
        currentBalance: Double
    ) {
        self.id = id
        self.accountID = accountID
        self.name = name
        self.subtype = subtype
        self.institutionID = institutionID
        self.isSyncingTransactions = isSyncingTransactions
        self.currentBalance = currentBalance
    }
}
