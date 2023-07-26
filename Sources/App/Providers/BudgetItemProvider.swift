//
//  BudgetItemProvider.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

protocol BudgetItemProviding {
    func save(_ item: FFBudgetItem, on database: Database) async throws
    func delete(_ item: FFBudgetItem, on database: Database) async throws
}

final class BudgetItemProvider: BudgetItemProviding {
    // MARK: - Dependencies
    @Injected(\.budgetItemStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func save(_ item: FFBudgetItem, on database: Database) async throws {
        let item = try BudgetItem(from: item)
        try await store.save(item, on: database)
    }
    
    func delete(_ item: FFBudgetItem, on database: Database) async throws {
        let item = try BudgetItem(from: item)
        try await store.delete(item, on: database)
    }
}
