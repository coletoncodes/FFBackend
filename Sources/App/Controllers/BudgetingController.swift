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
    @Injected(\.budgetCategoryProvider) private var budgetCategoryProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetingRoutes = routes.grouped("budgeting")
        budgetingRoutes.get("categories", ":userID", use: getBudgetCategories)
        budgetingRoutes.post("categories", use: postBudgetCategories)
        budgetingRoutes.delete("categories", use: deleteBudgetCategory)
    }
}

// MARK: - Public Requests
extension BudgetingController {
    // MARK: - BudgetCategories
    func getBudgetCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            guard let userID = req.parameters.get("userID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No USERID in URL.")
            }
            let budgetCategories =  try await budgetCategoryProvider.getCategories(userID: userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
        }
    }
    
    func postBudgetCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
        do {
            let body = try req.content.decode(FFPostBudgetCategoriesRequestBody.self)
            try await budgetCategoryProvider.save(categories: body.budgetCategories, database: req.db)
            let budgetCategories = try await budgetCategoryProvider.getCategories(userID: body.userID, database: req.db)
            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to save BudgetCategories.", error: error)
        }
    }
    
    func deleteBudgetCategory(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFDeleteBudgetCategoryRequestBody.self)
            try await budgetCategoryProvider.delete(category: body.budgetCategory, database: req.db)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete BudgetCategory.", error: error)
        }
        return .ok
    }
}

