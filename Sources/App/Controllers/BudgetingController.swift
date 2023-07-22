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
        budgetingRoutes.get(":userID", use: getBudget)
        budgetingRoutes.post("", use: postBudget)
        budgetingRoutes.delete("", use: deleteBudgetCategory)
    }
}

// MARK: - Public Requests
extension BudgetingController {
    func getBudget(req: Request) async throws -> FFBudgetResponse {
        do {
            guard let userID = req.parameters.get("userID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No USERID in URL.")
            }
            let budgetCategories =  try await budgetCategoryProvider.getCategories(userID: userID, database: req.db)
            return FFBudgetResponse(budgetCategories: budgetCategories)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
        }
    }
    
    func postBudget(req: Request) async throws -> FFBudgetResponse {
        do {
            let body = try req.content.decode(FFPostBudgetRequestBody.self)
            try await budgetCategoryProvider.save(categories: body.budgetCategories, database: req.db)
            let budgetCategories = try await budgetCategoryProvider.getCategories(userID: body.userID, database: req.db)
            return FFBudgetResponse(budgetCategories: budgetCategories)
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

