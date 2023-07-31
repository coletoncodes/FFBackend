//
//  BudgetItemRepository.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import Fluent
import Vapor

protocol BudgetItemStore {
    func save(_ item: BudgetItem, on db: Database) async throws
    func delete(_ item: BudgetItem, on db: Database) async throws
    func getItem(withID ID: UUID, on db: Database) async throws -> BudgetItem
}

final class BudgetItemRepository: BudgetItemStore {
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func save(_ item: BudgetItem, on db: Database) async throws {
        if let existingItem = try await BudgetItem
            .query(on: db)
            .filter(\.$id == item.requireID())
            .first() {
            existingItem.name = item.name
            existingItem.planned = item.planned
            existingItem.type = item.type
            try await existingItem.update(on: db)
            print("Updated Item: \(existingItem)")
        } else {
            try await item.create(on: db)
            print("Created Item: \(item)")
        }
    }
    
    func delete(_ item: BudgetItem, on db: Database) async throws {
        guard let fetchedItem = try await BudgetItem
            .query(on: db)
            .filter(\.$id == item.requireID())
            .first() else {
            throw Abort(.internalServerError, reason: "No matching item found.")
        }

        try await fetchedItem.delete(on: db)
    }
    
    func getItem(withID ID: UUID, on db: Database) async throws -> BudgetItem {
        guard let budgetItem = try await BudgetItem
            .query(on: db)
            .filter(\.$id == ID)
            .first() else {
            throw Abort(.internalServerError, reason: "No matching item found.")
        }
        return budgetItem
    }
}
