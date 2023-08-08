//
//  MonthlyBudgetRepository.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Fluent
import Vapor

protocol MonthlyBudgetStore {
    func save(_ monthlyBudget: MonthlyBudget, on db: Database) async throws
    func getMonthlyBudget(_ monthlyBudget: MonthlyBudget, on db: Database) async throws -> MonthlyBudget
}

final class MonthlyBudgetRepository: MonthlyBudgetStore {
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func save(_ monthlyBudget: MonthlyBudget, on db: Database) async throws {
        try await monthlyBudget.save(on: db)
    }
    
    func getMonthlyBudget(_ monthlyBudget: MonthlyBudget, on db: Database) async throws -> MonthlyBudget {
        guard let foundItem = try await MonthlyBudget
            .query(on: db)
            .filter(\.$id == monthlyBudget.requireID())
            .filter(\.$user.$id == monthlyBudget.$user.id)
            .first() else {
            throw Abort(.internalServerError, reason: "No MonthlyBudget exists")
        }
        
        return foundItem
    }
}
