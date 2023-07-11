//
//  FFInstitution.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFInstitution: Codable, Equatable, Hashable, Identifiable {
    public var id: String {
        name + (institutionID?.uuidString ?? "")
    }
    
    public let name: String
    public let institutionID: UUID?
    public var accounts: [FFBankAccount]
    
    public init(
        name: String,
        institutionID: UUID?,
        accounts: [FFBankAccount]
    ) {
        self.name = name
        self.institutionID = institutionID
        self.accounts = accounts
    }
}
