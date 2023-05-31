//
//  PlaidControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

@testable import App
import Fluent
import XCTVapor

final class PlaidControllerTests: XCTestCase {
    private var app: Application!
    private let testUserID = UUID() // Put your test user UUID here

    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
        app = Application(.testing)
        try await configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.shutdown()
        app = nil
    }

    // MARK: - func createLinkToken(_ req: Request)
    /// Test valid createLinkToken request succeeds
    func testCreateLinkTokenSuccess() throws {
        // Create a request with the test user's UUID
        let request = CreateLinkTokenRequest(userID: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!)
        
        try app.test(.POST, "plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            // Decode the response
            let responseBody = try res.content.decode(PlaidLinkTokenCreateResponse.self)
            // Check if link_token is non-empty
            XCTAssertFalse(responseBody.link_token.isEmpty)
        })
    }

    /// Test createLinkToken request with invalid userID fails
    func testCreateLinkTokenInvalidUserID() throws {
        // Create a request with invalid userID
        let randomUUID = UUID()
        let request = CreateLinkTokenRequest(userID: randomUUID)
        
        try app.test(.POST, "plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
}

