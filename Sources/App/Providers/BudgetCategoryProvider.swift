//
//  BudgetCategoryProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import FFAPI
import Foundation
import Factory
import Vapor

protocol BudgetCategoryProviding {
    func getCategories(userID: UUID, request: Request) async throws -> [FFBudgetCategory]
    func delete(category: FFBudgetCategory, request: Request) async throws
    func save(category: FFBudgetCategory, request: Request) async throws
    func save(categories: [FFBudgetCategory], request: Request) async throws
}

final class BudgetCategoryProvider: BudgetCategoryProviding {
    // MARK: - Dependencies
    @Injected(\.budgetCategoryStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func getCategories(userID: UUID, request: Request) async throws -> [FFBudgetCategory] {
        return try await store.getCategories(userID: userID, on: request.db)
            .map { FFBudgetCategory(from: $0) }
    }
    
    func delete(category: FFBudgetCategory, request: Request) async throws {
        let category = BudgetCategory(from: category)
        try await store.delete(category, on: request.db)
    }
    
    func save(category: FFBudgetCategory, request: Request) async throws {
        let category = BudgetCategory(from: category)
        try await store.save(category, on: request.db)
    }
    
    func save(categories: [FFBudgetCategory], request: Request) async throws {
        for category in categories {
            try await save(category: category, request: request)
        }
    }
}
