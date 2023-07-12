//
//  BudgetItemRepository.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Fluent
import Vapor

protocol BudgetItemStore {
    func getItems(categoryID: UUID, on db: Database) async throws -> [BudgetItem]
    func save(_ budgetItem: BudgetItem, on db: Database) async throws
    func save(_ budgetItems: [BudgetItem], on db: Database) async throws
    func delete(_ budgetItem: BudgetItem, on db: Database) async throws
}

final class BudgetItemRepository: BudgetItemStore {
    
    init() {}
    
    // MARK: - Interface
    func getItems(categoryID: UUID, on db: Database) async throws -> [BudgetItem] {
        try await BudgetItem
            .query(on: db)
            .filter(\.$budgetCategory.$id == categoryID)
            .with(\.$transactions)
            .all()
    }
    
    func save(_ budgetItem: BudgetItem, on db: Database) async throws {
        try await budgetItem.save(on: db)
    }
    
    func save(_ budgetItems: [BudgetItem], on db: Database) async throws {
        for item in budgetItems {
            try await save(item, on: db)
        }
    }
    
    func delete(_ budgetItem: BudgetItem, on db: Database) async throws {
        try await budgetItem.delete(on: db)
    }
}
