//
//  FFInstitution.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFInstitution: Codable {
    public let name: String
    public let institutionID: UUID?
    public let accounts: [FFBankAccount]
    
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
