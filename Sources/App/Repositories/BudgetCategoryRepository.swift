//
//  BudgetCategoryRepository.swift
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
        return try await BudgetCategory
            .query(on: db)
            .filter(\.$user.$id == userID)
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
    
    func delete(_ category: BudgetCategory, on database: Database) async throws {
        guard let fetchedCategory = try await BudgetCategory
            .query(on: database)
            .filter(\.$name == category.name)
            .filter(\.$user.$id == category.$user.id)
            .first() else {
            throw Abort(.internalServerError, reason: "No matching category found.")
        }

        try await fetchedCategory.delete(on: database)
    }
}
