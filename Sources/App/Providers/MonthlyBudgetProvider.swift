//
//  MonthlyBudgetProvider.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import FFAPI
import Foundation
import Factory
import Fluent

protocol MonthlyBudgetProviding {
    func save(_ ffMonthlyBudget: FFMonthlyBudget, on db: Database) async throws
    func getMonthlyBudget(_ ffMonthlyBudgetID: FFMonthlyBudget.ID, on db: Database) async throws -> FFMonthlyBudget
    func getAllMonthlyBudgets(_ userID: FFUser.ID, on db: Database) async throws -> [FFMonthlyBudget]
}

final class MonthlyBudgetProvider: MonthlyBudgetProviding {
    
    // MARK: - Dependencies
    @Injected(\.monthlyBudgetStore) private var store
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func save(_ ffMonthlyBudget: FFMonthlyBudget, on db: Database) async throws {
        let monthlyBudget = MonthlyBudget(from: ffMonthlyBudget)
        try await store.save(monthlyBudget, on: db)
    }
    
    func getMonthlyBudget(_ ffMonthlyBudgetID: FFMonthlyBudget.ID, on db: Database) async throws -> FFMonthlyBudget {
        let monthlyBudget = try await store.getMonthlyBudget(ffMonthlyBudgetID, on: db)
        return try FFMonthlyBudget(from: monthlyBudget)
    }
    
    func getAllMonthlyBudgets(_ userID: FFUser.ID, on db: Database) async throws -> [FFMonthlyBudget] {
        return try await store.getAllMonthlyBudgets(for: userID, on: db).map { try FFMonthlyBudget(from: $0) }
    }
}
