//
//  MonthlyBudgetControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

@testable import App
import FFAPI
import XCTVapor
import XCTest

final class MonthlyBudgetControllerTests: BudgetTestCase {
        
    // MARK: - Tests
    func test_PostMonthlyBudget_Success() throws {
        let postedMonthlyBudget = try postMonthlyBudget()
        XCTAssertNotNil(postedMonthlyBudget)
    }
    
    func test_GetMonthlyBudget_Success() throws {
        /** Given */
        let postedMonthlyBudget = try postMonthlyBudget()
        
        /** When */
        let getMonthlyBudgetPath = monthlyBudgetPath + "\(postedMonthlyBudget!.id)"
        try app.test(
            .GET, getMonthlyBudgetPath,
            headers: authHeaders,
            afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let response = try res.content.decode(FFMonthlyBudgetResponse.self)
                
                // Verify matches expected
                XCTAssertEqual(response.monthlyBudget, postedMonthlyBudget)
            })
    }
    
    func test_GetAllMonthlyBudgets_Success() throws {
        /** Given */
        let year = 2023
        var postedBudgets: [FFMonthlyBudget] = []

        // Create a budget month for every month.
        for month in 1...12 {
            guard let budget = try postMonthlyBudget(.init(id: .init(), userID: user.id, month: month, year: year)) else {
                break
            }
            postedBudgets.append(budget)
        }
        
        /** When */
        let getAllMonthlyBudgetsPath = monthlyBudgetPath + "all" + "/\(user.id)"
        try app.test(
            .GET, getAllMonthlyBudgetsPath,
            headers: authHeaders,
            afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let response = try res.content.decode(FFAllMonthlyBudgetsResponse.self)
                
                // Verify matches expected
                XCTAssertEqual(response.monthlyBudgets, postedBudgets)
            })
    }
}
