//
//  FFBudgetItem.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFBudgetItem: Codable, Hashable, Equatable {
    public let id: UUID
    public let budgetCategoryID: UUID
    public let type: FFCategoryType
    public let name: String
    public let planned: Double
    public let dueDate: Date?
    
    public init(
        id: UUID,
        budgetCategoryID: UUID,
        type: FFCategoryType = .expense,
        name: String = "",
        planned: Double = 0.0,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.budgetCategoryID = budgetCategoryID
        self.type = type
        self.name = name
        self.planned = planned
        self.dueDate = dueDate
    }
}
