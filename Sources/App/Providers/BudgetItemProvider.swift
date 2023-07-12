//
//  BudgetItemProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Factory
import FFAPI
import Foundation
import FluentKit

final class BudgetItemProvider {
    // MARK: - Dependencies
    @Injected(\.budgetItemStore) private var store
    
    // MARK: - Initializer
    
    // MARK: - Interface
    func getItems(categoryID: UUID, database: Database) async throws -> [FFBudgetItem] {
        try await store.getItems(categoryID: categoryID, on: database)
            .map { FFBudgetItem(from: $0) }
    }
    
    func delete(budgetItem: FFBudgetItem, database: Database) async throws {
        let budgetItem = BudgetItem(from: budgetItem)
        try await store.delete(budgetItem, on: database)
    }
}
