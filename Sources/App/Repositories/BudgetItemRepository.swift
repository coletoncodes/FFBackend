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
            try await existingItem.update(on: db)
        } else {
            try await item.save(on: db)
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
}
