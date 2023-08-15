//
//  FFTransaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFTransaction: Codable, Hashable, Equatable {
    public let id: UUID
    public let institutionID: UUID
    public let name: String
    public let amount: Double
    public let date: Date
    
    public init(
        id: UUID,
        institutionID: UUID,
        name: String,
        amount: Double,
        date: Date
    ) {
        self.id = id
        self.institutionID = institutionID
        self.name = name
        self.amount = amount
        self.date = date
    }
}
