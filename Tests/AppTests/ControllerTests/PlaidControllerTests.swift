//
//  PlaidControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

@testable import App
import Fluent
import XCTVapor

final class PlaidControllerTests: AuthenticatedTestCase {

    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK: - func createLinkToken(_ req: Request)
    /// Test valid createLinkToken request succeeds
    func testCreateLinkTokenSuccess() throws {
        // Get the authenticated user's id.
        let userID = sessionResponse.user.id!
        
        // Create a request with the test user's UUID
        let request = CreateLinkTokenRequest(userID: userID)
                
        try app.test(.POST, "api/plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
            req.headers.add(contentsOf: accessTokenHeader)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            // Decode the response
            let responseBody = try res.content.decode(PlaidCreateLinkTokenResponse.self)
            // Check if link_token is non-empty
            XCTAssertFalse(responseBody.link_token.isEmpty)
        })
    }

    /// Test createLinkToken request with invalid userID fails
    func testCreateLinkTokenInvalidUserID() throws {
        // Create a request with invalid userID
        let randomUUID = UUID()
        let request = CreateLinkTokenRequest(userID: randomUUID)
        
        try app.test(.POST, "api/plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
}

