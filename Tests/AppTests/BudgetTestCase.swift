//
//  BudgetTestCase.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

@testable import App
import FFAPI
import Fluent
import XCTVapor

class BudgetTestCase: AuthenticatedTestCase {
    var monthlyBudgetPath: String { "api/monthly-budget/" }
    var budgetCategoriesPath: String { "/api/categories/" }
    
    // MARK: - Interface
    func postMonthlyBudget(_ monthlyBudget: FFMonthlyBudget? = nil) throws -> FFMonthlyBudget? {
        var budgetToPost = FFMonthlyBudget(id: .init(), userID: user.id, month: 01, year: 2023)
        if let monthlyBudget = monthlyBudget {
            budgetToPost = monthlyBudget
        }
        
        let body = FFPostMonthlyBudgetRequestBody(monthlyBudget: budgetToPost)
        
        /** When */
        var postedBudget: FFMonthlyBudget?
        try app.test(
            .POST, monthlyBudgetPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let response = try res.content.decode(FFMonthlyBudgetResponse.self)
                
                // Verify matches expected
                XCTAssertEqual(response.monthlyBudget, budgetToPost)
                postedBudget = response.monthlyBudget
            })
        return postedBudget
    }
    
    func postBudgetCategories() throws -> [FFBudgetCategory] {
        
        guard let monthlyBudget = try postMonthlyBudget() else {
            XCTFail("Monthly Budget was nil.")
            return []
        }
        
        let budgetCategories = [
            FFBudgetCategory(id: .init(), monthlyBudgetID: monthlyBudget.id, name: "Test Category 1"),
            FFBudgetCategory(id: .init(), monthlyBudgetID: monthlyBudget.id, name: "Test Category 2"),
            FFBudgetCategory(id: .init(), monthlyBudgetID: monthlyBudget.id, name: "Test Category 3")
        ]
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: budgetCategories, monthlyBudgetID: monthlyBudget.id)
        
        /** When */
        var postedCategories: [FFBudgetCategory] = []
        try app.test(
            .POST, budgetCategoriesPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let response = try res.content.decode(FFBudgetCategoriesResponse.self)
                
                // Verify matches expected
                XCTAssertEqual(response.budgetCategories, budgetCategories)
                postedCategories = response.budgetCategories
            })
        return postedCategories
    }
}
