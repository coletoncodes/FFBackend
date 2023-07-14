//
//  BudgetCategoryProviderTests.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

@testable import App
import Fluent
import FFAPI
import XCTest

final class MockBudgetCategoryStore: BudgetCategoryStore {
    // stubs
    var getCategoriesStub: ((UUID, Database) async throws -> [BudgetCategory])!
    var saveStub: ((BudgetCategory, Database) async throws -> Void)!
    var deleteStub: ((BudgetCategory, Database) async throws -> Void)!
    
    func getCategories(userID: UUID, on db: Database) async throws -> [BudgetCategory] {
        try await getCategoriesStub(userID, db)
    }
    
    func save(_ category: BudgetCategory, on db: Database) async throws {
        try await saveStub(category, db)
    }
    
    func save(_ categories: [BudgetCategory], on db: Database) async throws {
        for category in categories {
            try await saveStub(category, db)
        }
    }
    
    func delete(_ category: BudgetCategory, on db: Database) async throws {
        try await saveStub(category, db)
    }
}

// TODO: Add tests
final class BudgetCategoryProviderTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
