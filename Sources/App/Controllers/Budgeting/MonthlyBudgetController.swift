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
    @Injected(\.budgetCategoryProvider) private var budgetCategoryProvider
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let budgetRoutes = routes.grouped("monthly-budget")
        // Post's a new monthly budget
        budgetRoutes.post("", use: postMonthlyBudget)
        // Get's the monthly budget for the given month and year.
        budgetRoutes.get(":month", ":year", use: getMonthlyBudget)
//        budgetRoutes.get(":userID", use: getCategories)
//        // Post's all categories
//        budgetRoutes.post("", use: postCategories)
//        // Delete's the category with the given ID.
//        budgetRoutes.delete(":categoryID", use: deleteBudgetCategory)
    }
}

// TODO: Move to FFAPI+
extension FFGetMonthlyBudgetRequestBody: Content {}
extension FFMonthlyBudgetResponse: Content {}
extension FFPostMonthlyBudgetRequestBody: Content {}

// TODO: Move to FFAPI
public struct FFGetMonthlyBudgetRequestBody: Codable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}

public struct FFMonthlyBudgetResponse: Codable {
    public let id: UUID
    public let month: Int
    public let year: Int
    
    public init(id: UUID, month: Int, year: Int) {
        self.id = id
        self.month = month
        self.year = year
    }
}

public struct FFPostMonthlyBudgetRequestBody: Codable {
    public let id: UUID
    public let month: Int
    public let year: Int
    
    public init(id: UUID, month: Int, year: Int) {
        self.id = id
        self.month = month
        self.year = year
    }
}

// MARK: - Public Requests
extension MonthlyBudgetController {
    
    func postMonthlyBudget(req: Request) async throws -> HTTPStatus {
        let body = try req.content.decode(FFGetMonthlyBudgetRequestBody.self)
        
        // TODO: Save the associated budget to the database
        return .ok
    }
    
    func getMonthlyBudget(req: Request) async throws -> FFMonthlyBudgetResponse {
        
        guard let month = req.parameters.get("month", as: Int.self) else {
            throw Abort(.badRequest, reason: "No month in URL.")
        }
        
        guard let year = req.parameters.get("year", as: Int.self) else {
            throw Abort(.badRequest, reason: "No year in URL.")
        }
        
        let body = try req.content.decode(FFGetMonthlyBudgetRequestBody.self)
        
        // TODO: Get the associated budget from the database
        return FFMonthlyBudgetResponse(id: .init(), month: 0, year: 0)
    }
    
//    func getCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
//        do {
//            guard let userID = req.parameters.get("userID", as: UUID.self) else {
//                throw Abort(.badRequest, reason: "No USERID in URL.")
//            }
//            let budgetCategories = try await budgetCategoryProvider.getCategories(for: userID, database: req.db)
//            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
//        } catch {
//            throw Abort(.internalServerError, reason: "Failed to get BudgetCategories.", error: error)
//        }
//    }
//
//    func postCategories(req: Request) async throws -> FFBudgetCategoriesResponse {
//        do {
//            let body = try req.content.decode(FFPostBudgetCategoriesRequestBody.self)
//            try await budgetCategoryProvider.save(categories: body.budgetCategories, database: req.db)
//            let budgetCategories = try await budgetCategoryProvider.getCategories(for: body.userID, database: req.db)
//            return FFBudgetCategoriesResponse(budgetCategories: budgetCategories)
//        } catch {
//            throw Abort(.internalServerError, reason: "Failed to save BudgetCategories.", error: error)
//        }
//    }
//
//    func deleteBudgetCategory(req: Request) async throws -> HTTPStatus {
//        do {
//            guard let categoryID = req.parameters.get("categoryID", as: UUID.self) else {
//                throw Abort(.badRequest, reason: "No categoryID in URL.")
//            }
//            try await budgetCategoryProvider.deleteCategory(with: categoryID, database: req.db)
//        } catch {
//            throw Abort(.internalServerError, reason: "Failed to delete BudgetCategory.", error: error)
//        }
//        return .ok
//    }
}
