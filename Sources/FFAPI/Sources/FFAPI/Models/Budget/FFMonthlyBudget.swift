//
//  FFMonthlyBudget.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

public struct FFMonthlyBudget: Codable, Hashable, Equatable, Identifiable {
    public let id: UUID
    public let userID: UUID
    public let month: Int
    public let year: Int
    
    public init(
        id: UUID,
        userID: UUID,
        month: Int,
        year: Int
    ) {
        self.id = id
        self.userID = userID
        self.month = month
        self.year = year
    }
}
