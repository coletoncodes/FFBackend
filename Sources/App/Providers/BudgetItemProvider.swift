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

protocol BudgetItemProviding {
    func getItems(categoryID: UUID, database: Database) async throws -> [FFBudgetItem]
    func delete(budgetItem: FFBudgetItem, database: Database) async throws
    func save(budgetItem: FFBudgetItem, database: Database) async throws
    func save(budgetItems: [FFBudgetItem], database: Database) async throws
}

final class BudgetItemProvider: BudgetItemProviding {
    // MARK: - Dependencies
    @Injected(\.budgetItemStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func getItems(categoryID: UUID, database: Database) async throws -> [FFBudgetItem] {
        try await store.getItems(categoryID: categoryID, on: database)
            .map { FFBudgetItem(from: $0) }
    }
    
    func delete(budgetItem: FFBudgetItem, database: Database) async throws {
        let budgetItem = BudgetItem(from: budgetItem)
        try await store.delete(budgetItem, on: database)
    }
    
    func save(budgetItem: FFBudgetItem, database: Database) async throws {
        // Create a budgetItem from a shared FFBudgetItem DTO object.
        let budgetItem = BudgetItem(from: budgetItem)
        // Save into the store.
        try await store.save(budgetItem, on: database)
    }
    
    func save(budgetItems: [FFBudgetItem], database: Database) async throws {
        for item in budgetItems {
            try await save(budgetItem: item, database: database)
        }
    }
}
