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
    private let budgetingCategoryPath = "/api/budgeting/categories"
    private let budgetingItemsPath = "/api/budgeting/items"
    
    // MARK: - func postBudgetCategories()
    func test_PostBudgetCategories_Success() throws {
        /** Given */
        let budgetCategory1 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 1", budgetItems: [], categoryType: .expense)
        let budgetCategory2 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 2", budgetItems: [], categoryType: .expense)
        let budgetCategories = [budgetCategory1, budgetCategory2]
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: budgetCategories, userID: user.id!)
        
        /** When */
        try app.test(
            .POST, budgetingCategoryPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetCategoriesResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetCategories.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetCategories, budgetCategories)
            })
    }
    
    // MARK: - func getBudgetCategories()
    func test_GetBudgetCategories_Success() throws {
        /** Given */
        let budgetCategory1 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 1", budgetItems: [], categoryType: .expense)
        let budgetCategory2 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 2", budgetItems: [], categoryType: .expense)
        let budgetCategories = [budgetCategory1, budgetCategory2]
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: budgetCategories, userID: user.id!)
        
        /** When */
        // We post the categories first.
        try app.test(
            .POST, budgetingCategoryPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetCategoriesResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetCategories.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetCategories, budgetCategories)
            })
        
        /** Given */
        let getCategoriesBody = FFGetBudgetCategoriesRequestBody(userID: user.id!)
        
        /** When */
        try app.test(
            .GET, budgetingCategoryPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(getCategoriesBody)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetCategoriesResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetCategories.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetCategories, budgetCategories)
            })
    }
    
    // MARK: - func postBudgetItems()
    // TODO: This doesn't pass. No idea why
    func test_PostBudgetItems_Success() throws {
        /** Given */
        let budgetCategory1 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 1", budgetItems: [], categoryType: .expense)
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: [budgetCategory1], userID: user.id!)
        
        /** When */
        // We post the budgetCategories
        try app.test(
            .POST, budgetingCategoryPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(body)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
            })
        
        let budgetItem1 = FFBudgetItem(id: UUID(), name: "Test Budget Item 1", budgetCategoryID: budgetCategory1.id!, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItem2 = FFBudgetItem(id: UUID(), name: "Test Budget Item 2", budgetCategoryID: budgetCategory1.id!, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItems = [budgetItem1, budgetItem2]
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: budgetItems, categoryID: budgetCategory1.id!)
        
        /** When */
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
    }
    
    func test_GetBudgetItems_Success() throws {
        /** Given */
        let budgetCategoryID = UUID()
        let budgetItem1 = FFBudgetItem(id: UUID(), name: "Test Budget Item 1", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItem2 = FFBudgetItem(id: UUID(), name: "Test Budget Item 2", budgetCategoryID: budgetCategoryID, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        let budgetItems = [budgetItem1, budgetItem2]
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: budgetItems, categoryID: budgetCategoryID)
        
        /** When */
        // We post the items first
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
        let getBudgetItemsBody = FFGetBudgetItemsRequestBody(categoryID: budgetCategoryID)
        
        /** When */
        try app.test(
            .GET, budgetingItemsPath, headers: authHeaders,
            beforeRequest: { req in
                try req.content.encode(getBudgetItemsBody)
            }, afterResponse: { res in
                
                /** Then */
                XCTAssertEqual(res.status, .ok)
                
                let responseBody = try res.content.decode(FFBudgetItemsResponse.self)
                // Verify response body is not empty
                XCTAssertFalse(responseBody.budgetItems.isEmpty)
                
                // Verify matches expected
                XCTAssertEqual(responseBody.budgetItems, budgetItems)
            })
        
        /** Then */
    }
}

