//
//  BudgetProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

protocol BudgetProviding {
    func getBudgetFor(userID: UUID, database: Database) async throws -> [FFBudgetCategory]
    func delete(category: FFBudgetCategory, database: Database) async throws
    func save(category: FFBudgetCategory, database: Database) async throws
    func save(categories: [FFBudgetCategory], database: Database) async throws
}

final class BudgetProvider: BudgetProviding {
    // MARK: - Dependencies
    @Injected(\.budgetCategoryStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func getBudgetFor(userID: UUID, database: Database) async throws -> [FFBudgetCategory] {
        return try await store.getCategories(userID: userID, on: database)
            .map { try FFBudgetCategory(from: $0) }
    }
    
    func delete(category: FFBudgetCategory, database: Database) async throws {
        let category = BudgetCategory(from: category)
        try await store.delete(category, on: database)
    }
    
    func save(category: FFBudgetCategory, database: Database) async throws {
        let category = BudgetCategory(from: category)
        try await store.save(category, on: database)
    }
    
    func save(categories: [FFBudgetCategory], database: Database) async throws {
        let categories = categories.map { BudgetCategory(from: $0) }
        try await store.save(categories, on: database)
    }
}
