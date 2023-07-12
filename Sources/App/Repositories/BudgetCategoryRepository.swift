//
//  File.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Fluent
import Vapor

protocol BudgetCategoryStore {
    func getCategories(userID: UUID, on db: Database) async throws -> [BudgetCategory]
    func save(_ category: BudgetCategory, on db: Database) async throws
    func save(_ categories: [BudgetCategory], on db: Database) async throws
    func delete(_ category: BudgetCategory, on db: Database) async throws
}

final class BudgetCategoryRepository: BudgetCategoryStore {
    
    init() {}
    
    func getCategories(userID: UUID, on db: Database) async throws -> [BudgetCategory] {
        try await BudgetCategory
            .query(on: db)
            .filter(\.$user.$id == userID)
            .with(\.$budgetItems)
            .all()
    }
    
    func save(_ category: BudgetCategory, on db: Database) async throws {
        try await category.save(on: db)
    }
    
    func save(_ categories: [BudgetCategory], on db: Database) async throws {
        for category in categories {
            try await save(category, on: db)
        }
    }
    
    func delete(_ category: BudgetCategory, on db: Database) async throws {
        try await category.delete(on: db)
    }
}
