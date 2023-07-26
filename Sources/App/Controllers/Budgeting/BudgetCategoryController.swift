//
//  BudgetCategoryController.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Factory
import FFAPI
import Vapor

final class BudgetCategoryController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.budgetCategoryProvider) private var budgetCategoryProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetingRoutes = routes.grouped("categories")
        // Get's all categories for a user
        budgetingRoutes.get(":userID", use: getCategories)
        // Post's all categories
        budgetingRoutes.post("", use: postBudget)
        // Delete's the category with the given ID.
        budgetingRoutes.delete(":categoryID", use: deleteBudgetCategory)
    }
}

// MARK: - Public Requests
extension BudgetCategoryController {
    func getCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            guard let userID = req.parameters.get("userID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No USERID in URL.")
            }
            let budgetCategories = try await budgetCategoryProvider.getCategories(for: userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
        }
    }
    
    func postBudget(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            let body = try req.content.decode(FFPostBudgetCategoriesRequestBody.self)
            try await budgetCategoryProvider.save(categories: body.budgetCategories, database: req.db)
            let budgetCategories = try await budgetCategoryProvider.getCategories(for: body.userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to save BudgetCategories.", error: error)
        }
    }
    
    func deleteBudgetCategory(req: Request) async throws -> HTTPStatus {
        do {
            guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No categoryID in URL.")
            }
            try await budgetCategoryProvider.deleteCategory(with: categoryID, database: req.db)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete BudgetCategory.", error: error)
        }
        return .ok
    }
}
