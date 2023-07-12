//
//  FFGetBudgetItemsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public struct FFGetBudgetItemsRequest: Codable {
    public let categoryID: UUID
    
    public init(categoryID: UUID) {
        self.categoryID = categoryID
    }
}
