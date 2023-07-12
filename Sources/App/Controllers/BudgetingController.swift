//
//  BudgetingController.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Factory
import FFAPI
import Vapor

final class BudgetingController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.budgetItemProvider) private var budgetItemProvider
    @Injected(\.budgetCategoryProvider) private var budgetCategoryProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetingRoutes = routes.grouped("budgeting")
        budgetingRoutes.get("categories", use: getBudgetCategories)
        budgetingRoutes.get("items", use: getBudgetItems)
    }
}

// MARK: - Public Requests
extension BudgetingController {
    
    func getBudgetCategories(req: Request) async throws -> [FFBudgetCategory] {
        let request = try req.content.decode(FFGetBudgetCategoriesRequest.self)
        return try await budgetCategoryProvider.getCategories(userID: request.userID, database: req.db)
    }
    
    func getBudgetItems(req: Request) async throws -> [FFBudgetItem] {
        let request = try req.content.decode(FFGetBudgetItemsRequest.self)
        return try await budgetItemProvider.getItems(categoryID: request.categoryID, database: req.db)
    }
}
