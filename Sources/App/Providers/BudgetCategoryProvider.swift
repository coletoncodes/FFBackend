//
//  BudgetCategoryProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

protocol BudgetCategoryProviding {
    func getCategories(for userID: UUID, database: Database) async throws -> [FFBudgetCategory]
    func deleteCategory(with id: UUID, database: Database) async throws
    func save(categories: [FFBudgetCategory], database: Database) async throws
}

final class BudgetCategoryProvider: BudgetCategoryProviding {
    // MARK: - Dependencies
    @Injected(\.budgetCategoryStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func getCategories(for userID: UUID, database: Database) async throws -> [FFBudgetCategory] {
        return try await store.getCategories(for: userID, on: database)
            .map { try FFBudgetCategory(from: $0) }
    }
    
    func deleteCategory(with id: UUID, database: Database) async throws {
        try await store.deleteCategory(with: id, on: database)
    }
    
    func save(categories: [FFBudgetCategory], database: Database) async throws {
        let categories = categories.map { BudgetCategory(from: $0) }
        try await store.save(categories, on: database)
    }
}
