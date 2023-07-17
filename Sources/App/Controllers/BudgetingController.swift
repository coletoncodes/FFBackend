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
        // categories
        budgetingRoutes.get("categories", use: getBudgetCategories)
        budgetingRoutes.post("categories", use: postBudgetCategories)
        budgetingRoutes.delete("categories", use: deleteBudgetCategory)
        // items
        budgetingRoutes.get("items", use: getBudgetItems)
        budgetingRoutes.post("items", use: postBudgetItems)
        budgetingRoutes.delete("items", use: deleteBudgetItem)
    }
}

// MARK: - Public Requests
extension BudgetingController {
    // MARK: - BudgetCategories
    func getBudgetCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            let body = try req.content.decode(FFGetBudgetCategoriesRequestBody.self)
            let budgetCategories =  try await budgetCategoryProvider.getCategories(userID: body.userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories. Error: \(error)")
        }
    }
    
    func postBudgetCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            let body = try req.content.decode(FFPostBudgetCategoriesRequestBody.self)
            try await budgetCategoryProvider.save(categories: body.budgetCategories, database: req.db)
            let budgetCategories = try await budgetCategoryProvider.getCategories(userID: body.userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to save BudgetCategories. Error: \(error)")
        }
    }
    
    func deleteBudgetCategory(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFDeleteBudgetCategoryRequestBody.self)
            try await budgetCategoryProvider.delete(category: body.budgetCategory, database: req.db)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete BudgetCategory. Error: \(error)")
        }
        return .ok
    }
    
    // TODO: move to new file
    public struct FFDeleteBudgetCategoryRequestBody: Codable {
        public let budgetCategory: FFBudgetCategory
        
        public init(budgetCategory: FFBudgetCategory) {
            self.budgetCategory = budgetCategory
        }
    }
    
    public struct FFDeleteBudgetItemRequestBody: Codable {
        public let budgetItem: FFBudgetItem
        
        public init(budgetItem: FFBudgetItem) {
            self.budgetItem = budgetItem
        }
    }
    
    // MARK: - Budget Items
    func getBudgetItems(req: Request) async throws -> FFBudgetItemsResponse {
        do {
            let body = try req.content.decode(FFGetBudgetItemsRequestBody.self)
            let budgetItems = try await budgetItemProvider.getItems(categoryID: body.categoryID, database: req.db)
            return FFBudgetItemsResponse(budgetItems: budgetItems)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetItems. Error: \(error)")
        }
    }
    
    func postBudgetItems(req: Request) async throws -> FFBudgetItemsResponse {
        do {
            let body = try req.content.decode(FFPostBudgetItemsRequestBody.self)
            try await budgetItemProvider.save(budgetItems: body.budgetItems, database: req.db)
            let budgetItems = try await budgetItemProvider.getItems(categoryID: body.categoryID, database: req.db)
            return FFBudgetItemsResponse(budgetItems: budgetItems)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to post BudgetItems. Error: \(error)")
        }
    }
    
    func deleteBudgetItem(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFDeleteBudgetItemRequestBody.self)
            try await budgetItemProvider.delete(budgetItem: body.budgetItem, database: req.db)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete BudgetItem. Error: \(error)")
        }
        return .ok
    }
}

