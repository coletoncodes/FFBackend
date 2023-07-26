//
//  BudgetItemControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

@testable import App
import FFAPI
import XCTVapor
import XCTest

final class BudgetItemControllerTests: AuthenticatedTestCase {
    private var budgetItemsPath: String {
        "/api/items"
    }
    
    private var budgetCategoriesPath: String {
        "/api/categories/"
    }
    
    // MARK: - Helpers
    private func postBudgetCategory() throws -> FFBudgetCategory {
        let budgetCategories = [
            FFBudgetCategory(id: .init(), userID: user.id!, name: "Test Category 1")
        ]
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: budgetCategories, userID: user.id!)
        
        /** When */
        var postedCategory: FFBudgetCategory?
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
                postedCategory = response.budgetCategories[0]
            })
        return postedCategory!
    }
    
    // MARK: - func postBudgetItem()
    func test_PostBudgetItem_Success() throws {
        /** Given */
        let category = try postBudgetCategory()
        let budgetItem = FFBudgetItem(id: .init(), budgetCategoryID: category.id, name: "Test Budget Item 1", planned: 10.00, dueDate: nil)
        let body = FFBudgetItemRequestBody(budgetItem: budgetItem)
        
        /** When */
        // we post the item
        try app.test(
            .POST, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
    }
    
    // MARK: - func deleteBudgetItem()
    func test_DeleteBudgetItem_Success() throws {
        /** Given */
        let category = try postBudgetCategory()
        let budgetItem = FFBudgetItem(id: .init(), budgetCategoryID: category.id, name: "Test Budget Item 1", planned: 10.00, dueDate: nil)
        let body = FFBudgetItemRequestBody(budgetItem: budgetItem)
        
        /** When */
        // we post the item first
        try app.test(
            .POST, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
        
        /** When */
        // we delete the item
        try app.test(
            .DELETE, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
            try req.content.encode(body)
        }, afterResponse: { res in
            /** Then */
            XCTAssertEqual(res.status, .ok)
        })
    }
}
