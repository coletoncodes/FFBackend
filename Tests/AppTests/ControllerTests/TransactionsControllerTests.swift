//
//  TransactionsControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

@testable import App
import FFAPI
import XCTVapor
import XCTest

final class TransactionsControllerTests: AuthenticatedTestCase {
    // MARK: - Properties
    private let transactionsPath = "/api/transactions"
    private let budgetingCategoryPath = "/api/budgeting/categories"
    private let budgetingItemsPath = "/api/budgeting/items"
    private var budgetItemID: UUID?
    
    private var transactions: [FFTransaction] {
        let dateString = "2023-07-16"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        let date = dateFormatter.date(from: dateString)!
        let transaction1 = FFTransaction(id: nil, name: "Test Transaction 1", budgetItemID: budgetItemID!, amount: 10.00, date: date, transactionType: .expense)
        let transaction2 = FFTransaction(id: nil, name: "Test Transaction 2", budgetItemID: budgetItemID!, amount: 100.00, date: date, transactionType: .expense)
        return [transaction1, transaction2]
    }
    
    // MARK: - LifeCycle
    override func setUp() async throws {
        try await super.setUp()
        try createBudgetItem()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func createBudgetItem() throws {
        /** Given */
        let budgetCategory1 = FFBudgetCategory(id: UUID(), userID: user.id!, name: "Test Category 1", budgetItems: [], categoryType: .expense)
        let body = FFPostBudgetCategoriesRequestBody(budgetCategories: [budgetCategory1], userID: user.id!)
        let budgetItem1 = FFBudgetItem(id: budgetItemID, name: "Test Budget Item 1", budgetCategoryID: budgetCategory1.id!, planned: 100.00, transactions: [], note: "With Note", dueDate: nil)
        
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
        
        let postBudgetItemsBody = FFPostBudgetItemsRequestBody(budgetItems: [budgetItem1], categoryID: budgetCategory1.id!)
        
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
                    budgetItemID = responseBody.budgetItems[0].id
                } catch {
                    XCTFail("Error: \(error)")
                }
                
            })
    }
    
    private func postTransactions() async throws {
        // Create test transactions with date having only day, month, and year components
        let postTransactionsBody = FFPostTransactionsRequestBody(budgetItemID: budgetItemID!, transactions: transactions)
        
        /** When */
        // we post the transactions first
        try app.test(.POST, transactionsPath, headers: authHeaders, beforeRequest: { req in
            try req.content.encode(postTransactionsBody)
        }, afterResponse: { res in
            /** Then */
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFGetTransactionsResponse.self)
            XCTAssertEqual(response.transactions, transactions)
        })
    }

    
    // MARK: - postTransactions()
    func test_PostTransactions_Success() async throws {
        try await postTransactions()
    }
    
    // MARK: - getTransactions()
    func test_GetTransactions_Success() async throws {
        try await postTransactions()
        
        let getTransactionsBody = FFGetTransactionsRequestBody(budgetItemID: budgetItemID!)
        
        /** When */
        // we fetch the new transactions
        try app.test(.GET, transactionsPath, headers: authHeaders, beforeRequest: { req in
            try req.content.encode(getTransactionsBody)
        }, afterResponse: { res in
            /** Then */
            XCTAssertEqual(res.status, .ok)
            
            let response = try res.content.decode(FFGetTransactionsResponse.self)
            // Verify matches expected
            XCTAssertEqual(response.transactions, transactions)
        })
    }
}
