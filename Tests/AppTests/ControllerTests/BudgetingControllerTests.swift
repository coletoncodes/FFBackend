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
    private var budgetingCategoryPath: String {
        "/api/budgeting/categories/"
    }
    
    private var budgetingItemsPath: String {
        "/api/budgeting/items/"
    }
    
    // MARK: - Helpers
    private func postBudgetCategories() throws -> [FFBudgetCategory] {
        let budgetCategory1 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 1", budgetItems: [], categoryType: .expense)
        let budgetCategory2 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 2", budgetItems: [], categoryType: .income)
        let budgetCategories = [budgetCategory1, budgetCategory2]
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: budgetCategories, userID: user.id!)
        
        /** When */
        var postedCategories: [FFBudgetCategory] = []
        try app.test(
            .POST, budgetingCategoryPath, headers: authHeaders,
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
        let getPath = budgetingCategoryPath + "\(user.id!)"
        try app.test(
            .GET, getPath, headers: authHeaders, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetCategoriesResponse.self)
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
            .DELETE, budgetingCategoryPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(deleteCategoryBody)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
    }
    
    // MARK: - func postBudgetItems()
    func test_PostBudgetItems_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetCategory = categories.first!
        let budgetItem1 = FFBudgetItem(id: UUID(), name: "Test Budget Item 1", budgetCategoryID: budgetCategory.id!, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        
        let budgetItem2 = FFBudgetItem(id: UUID(), name: "Test Budget Item 2", budgetCategoryID: budgetCategory.id!, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItems = [budgetItem1, budgetItem2]
        
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: budgetItems, categoryID: budgetCategory.id!)
        
        /** When */
        try app.test(
            .POST, budgetingItemsPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(postBudgetItemsBody)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                do {
                    let responseBody = try res.content.decode(FFBudgetItemsResponse.self)
                    // Verify response body is not empty
                    XCTAssertFalse(responseBody.budgetItems.isEmpty)
                    // Verify matches expected
                    XCTAssertEqual(responseBody.budgetItems, budgetItems)
                    
                    // Verify transactions populate
                    XCTAssertTrue(responseBody.budgetItems[0].transactions.isEmpty)
                } catch {
                    XCTFail("Error: \(error)")
                }
                
            })
    }
    
    // MARK: - funcGetBudgetItems()
    func test_GetBudgetItems_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetCategory = categories.first!
        let budgetCategoryID = budgetCategory.id!
        
        let budgetItem1 = FFBudgetItem(id: UUID(), name: "Test Budget Item 1", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItem2 = FFBudgetItem(id: UUID(), name: "Test Budget Item 2", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItems = [budgetItem1, budgetItem2]
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: budgetItems, categoryID: budgetCategoryID)
        
        /** When */
        
        // We post the items
        try app.test(
            .POST, budgetingItemsPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(postBudgetItemsBody)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemsResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetItems.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetItems, budgetItems)
            })
        
        /** When */
        let getPath = budgetingItemsPath + "\(budgetCategoryID)"
        // get the newly posted categories
        try app.test(
            .GET, getPath, headers: authHeaders, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemsResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetItems.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetItems, budgetItems)
            })
    }
    
    // MARK: - deleteBudgetItem()
    func test_DeleteBudgetItem_Success() throws {
        /** Given */
        let categories = try postBudgetCategories()
        let budgetCategory = categories.first!
        let budgetCategoryID = budgetCategory.id!
        
        let budgetItem1 = FFBudgetItem(id: UUID(), name: "Test Budget Item 1", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItem2 = FFBudgetItem(id: UUID(), name: "Test Budget Item 2", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItems = [budgetItem1, budgetItem2]
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: budgetItems, categoryID: budgetCategoryID)
                        
        // We post the items
        try app.test(
            .POST, budgetingItemsPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(postBudgetItemsBody)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemsResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetItems.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetItems, budgetItems)
            })
        
        /** Given */
        let deleteBudgetItemBody = FFDeleteBudgetItemRequestBody(budgetItem: budgetItem1)
        
        /** When */
        // we call delete
        try app.test(
            .DELETE, budgetingItemsPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(deleteBudgetItemBody)
            }, afterResponse: { res in
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
    }
}

