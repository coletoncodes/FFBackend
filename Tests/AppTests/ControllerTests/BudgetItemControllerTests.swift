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

final class BudgetItemControllerTests: BudgetTestCase {
    private var budgetItemsPath: String {
        "/api/items"
    }
    
    // MARK: - func postBudgetItem()
    func test_PostBudgetItem_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetItem = FFBudgetItem(id: .init(), budgetCategoryID: categories[0].id, name: "Test Budget Item 1", planned: 10.00)
        let body = FFBudgetItemRequestBody(budgetItem: budgetItem)
        
        /** When */
        // we post the item
        try app.test(
            .POST, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
                let responseBody = try res.content.decode(FFBudgetItemResponse.self)
                XCTAssertEqual(responseBody.budgetItem, budgetItem)
            })
    }
    
    // MARK: - func deleteBudgetItem()
    func test_DeleteBudgetItem_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetItem = FFBudgetItem(id: .init(), budgetCategoryID: categories[0].id, name: "Test Budget Item 1", planned: 10.00)
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
    
    func test_SaveBudgetItem_Updates_Successfully() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetCategoryID = categories[0].id
        let budgetItem = FFBudgetItem(id: .init(), budgetCategoryID: budgetCategoryID, name: "Test Budget Item 1", planned: 10.00)
        let body = FFBudgetItemRequestBody(budgetItem: budgetItem)
        
        /** When */
        // we post the budget item first
        try app.test(
            .POST, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemResponse.self)
                XCTAssertEqual(responseBody.budgetItem, budgetItem)
            })
        
        /** Given */
        // we modify the existing budgetItem
        let updatedBudgetItem = FFBudgetItem(id: budgetItem.id, budgetCategoryID: budgetCategoryID, name: "Updated Budget Item", planned: 150.0)
        let updateBody = FFBudgetItemRequestBody(budgetItem: updatedBudgetItem)
        
        /** When */
        try app.test(
            .POST, budgetItemsPath, headers: authHeaders, beforeRequest: { req in
                try req.content.encode(updateBody)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemResponse.self)
                XCTAssertEqual(responseBody.budgetItem, updatedBudgetItem)
            })
    }
}
