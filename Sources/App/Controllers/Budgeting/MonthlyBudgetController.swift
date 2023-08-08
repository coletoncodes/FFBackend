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
        // Get's the monthly budget for the given month and year.
        budgetRoutes.get(":monthlyBudgetID", use: getMonthlyBudget)
    }
}

// MARK: - Public Requests
extension MonthlyBudgetController {
    
    func postMonthlyBudget(req: Request) async throws -> HTTPStatus {
        do {
            let body = try req.content.decode(FFPostMonthlyBudgetRequestBody.self)
            try await provider.save(body.monthlyBudget, on: req.db)
            return .ok
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
}
