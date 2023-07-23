//
//  BudgetingControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 7/12/23.
//

@testable import App
import FFAPI
import XCTVapor
import XCTest

final class BudgetingControllerTests: AuthenticatedTestCase {
    private var budgetingPath: String {
        "/api/budgeting/"
    }
    
    // MARK: - Helpers
    private func postBudgetCategories() throws -> [FFBudgetCategory] {
        let budgetItem1 = FFBudgetItem(id: .init(), name: "Budget Item 1", planned: 10.00, transactions: [], note: "A note", dueDate: nil)
        let budgetItem2 = FFBudgetItem(
            id: .init(),
            name: "Budget Item 2",
            planned: 1000.00,
            transactions: [
                FFTransaction(name: "Transaction 1", amount: 10.00, date: try CustomDateFormatter.toRoundedDate(from: "2023-09-13"), transactionType: .expense),
                FFTransaction(name: "Transaction 2", amount: 10.00, date: try CustomDateFormatter.toRoundedDate(from: "2023-09-15"), transactionType: .expense)
            ],
            note: "A note",
            dueDate: nil
        )
        let budgetCategory1 = FFBudgetCategory(id: .init(), userID: user.id!, name: "Test Category 1", budgetItems: [budgetItem1])
        let budgetCategory2 = FFBudgetCategory(id: .init(), userID: user.id!, name: "Test Category 2", budgetItems: [budgetItem1, budgetItem2])
        let budgetCategories = [budgetCategory1, budgetCategory2]
        let body = FFPostBudgetRequestBody(budgetCategories: budgetCategories, userID: user.id!)
        
        /** When */
        var postedCategories: [FFBudgetCategory] = []
        try app.test(
            .POST, budgetingPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let response = try res.content.decode(FFBudgetResponse.self)
                
                // Verify matches expected
                XCTAssertEqual(response.budgetCategories, budgetCategories)
                postedCategories = response.budgetCategories
            })
        return postedCategories
    }
    
    // MARK: - func postBudgetCategories()
    func test_PostBudgetCategories_Success() throws {
        let categories = try postBudgetCategories()
        XCTAssertFalse(categories.isEmpty)
    }
    
    // MARK: - func getBudgetCategories()
    func test_GetBudgetCategories_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        
        /** When */
        let getPath = budgetingPath + "\(user.id!)"
        try app.test(
            .GET, getPath, headers: authHeaders, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetCategories.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetCategories, categories)
            })
    }
    
    // MARK: - func deleteBudgetCategory()
    func test_DeleteBudgetCategory_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        
        /** Given */
        let deleteCategoryBody = FFDeleteBudgetCategoryRequestBody(budgetCategory: categories[0])
        
        /** When */
        // We delete the category
        try app.test(
            .DELETE, budgetingPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(deleteCategoryBody)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
    }
}

