//
//  BudgetItemController.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import Factory
import FFAPI
import Vapor

final class BudgetItemController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.budgetItemProvider) private var budgetItemProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetingRoutes = routes.grouped("items")
        // Post's the item to the given category
        budgetingRoutes.post("", use: postItem)
        // Delete's the budgetItem
        budgetingRoutes.delete("", use: deleteBudgetItem)
    }
}

// MARK: - Public Requests
extension BudgetItemController {
    func postItem(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFBudgetItemRequestBody.self)
            try await budgetItemProvider.save(body.budgetItem, on: req.db)
            return .ok
        } catch {
            throw Abort(.internalServerError, reason: "Failed to post BudgetItem.", error: error)
        }
    }
    
    func deleteBudgetItem(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFBudgetItemRequestBody.self)
            try await budgetItemProvider.delete(body.budgetItem, on: req.db)
            return .ok
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete BudgetItem.", error: error)
        }
    }
}
