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

final class MonthlyBudgetControllerTests: AuthenticatedTestCase {
    // MARK: - Properties
    private var monthlyBudgetPath: String { "api/monthly-budget/" }
    
    // MARK: - Helpers
    private func postMonthlyBudget() async throws -> FFMonthlyBudget? {
        let janBudget = FFMonthlyBudget(id: .init(), userID: user.id!, month: 01, year: 2023)
        
        let body = FFPostMonthlyBudgetRequestBody(monthlyBudget: janBudget)
        
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
                XCTAssertEqual(response.monthlyBudget, janBudget)
                postedBudget = response.monthlyBudget
            })
        return postedBudget
    }
    
    // MARK: - Tests
    func test_PostMonthlyBudget_Success() async throws {
        let postedMonthlyBudget = try await postMonthlyBudget()
        XCTAssertNotNil(postedMonthlyBudget)
    }
    
    func test_GetMonthlyBudget_Success() async throws {
        /** Given */
        let postedMonthlyBudget = try await postMonthlyBudget()
        
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
}
