//
//  MonthlyBudgetController.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Factory
import FFAPI
import Vapor

final class MonthlyBudgetController: RouteCollection {
    // MARK: - Dependencies
    @Injected(\.monthlyBudgetProvider) private var provider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetRoutes = routes.grouped("monthly-budget")
        // Post's a new monthly budget
        budgetRoutes.post("", use: postMonthlyBudget)
        // Get's the monthly budget for the given monthlyBudgetID.
        budgetRoutes.get(":monthlyBudgetID", use: getMonthlyBudget)
        // Get's all the monthly budget item's for a given user.
        budgetRoutes.get("all", ":userID", use: getAllMonthlyBudgetsForUser)
    }
}

// MARK: - Public Requests
extension MonthlyBudgetController {
    
    func postMonthlyBudget(req: Request) async throws -> FFMonthlyBudgetResponse {
        do {
            let body = try req.content.decode(FFPostMonthlyBudgetRequestBody.self)
            try await provider.save(body.monthlyBudget, on: req.db)
            
            let monthlyBudget = try await provider.getMonthlyBudget(body.monthlyBudget.id, on: req.db)
            return FFMonthlyBudgetResponse(monthlyBudget: monthlyBudget)
        } catch {
            let errorStr = "Failed to save monthly budget"
            req.logger.error("\(errorStr)")
            throw Abort(.internalServerError, reason: errorStr, error: error)
        }
    }
    
    func getMonthlyBudget(req: Request) async throws -> FFMonthlyBudgetResponse {
        do {
            guard let monthlyBudgetID = req.parameters.get("monthlyBudgetID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No month in URL.")
            }
            
            let monthlyBudget = try await provider.getMonthlyBudget(monthlyBudgetID, on: req.db)
            return FFMonthlyBudgetResponse(monthlyBudget: monthlyBudget)
        } catch {
            let errorStr = "Failed to get monthly budget"
            req.logger.error("\(errorStr)")
            throw Abort(.internalServerError, reason: errorStr, error: error)
        }
    }
    
    func getAllMonthlyBudgetsForUser(req: Request) async throws -> FFAllMonthlyBudgetsResponse {
        do {
            guard let userID = req.parameters.get("userID", as: UUID.self) else {
                throw Abort(.badRequest, reason: "No userID in URL.")
            }
            
            let monthlyBudgets = try await provider.getAllMonthlyBudgets(userID, on: req.db)
            return FFAllMonthlyBudgetsResponse(monthlyBudgets: monthlyBudgets)
        } catch {
            let errorStr = "Failed to get monthly budgets for user"
            req.logger.error("\(errorStr)")
            throw Abort(.internalServerError, reason: errorStr, error: error)
        }
    }
}
