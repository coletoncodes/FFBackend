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
        let body = try req.content.decode(FFGetBudgetCategoriesRequestBody.self)
        return try await budgetCategoryProvider.getCategories(userID: body.userID, database: req.db)
    }
    
    func getBudgetItems(req: Request) async throws -> [FFBudgetItem] {
        let body = try req.content.decode(FFGetBudgetItemsRequestBody.self)
        return try await budgetItemProvider.getItems(categoryID: body.categoryID, database: req.db)
    }
}
