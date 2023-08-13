//
//  PlaidLinkControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

@testable import App
import FFAPI
import Fluent
import XCTVapor

final class PlaidLinkControllerTests: AuthenticatedTestCase {

    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // MARK: - func createLinkToken(_ req: Request)
    /// Test valid createLinkToken request succeeds
    func test_CreateLinkToken_Success() throws {
        // Get the authenticated user's id.
        let userID = sessionResponse.user.id
        
        // Create a request with the test user's UUID
        let request = FFCreateLinkTokenRequestBody(userID: userID)
                
        try app.test(.POST, "api/plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
            req.headers.add(contentsOf: authHeaders)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            // Decode the response
            let responseBody = try res.content.decode(FFCreateLinkTokenResponse.self)
            // Check if linkToken is non-empty
            XCTAssertFalse(responseBody.linkToken.isEmpty)
        })
    }

    /// Test createLinkToken request with invalid userID fails
    func test_CreateLinkTokenInvalidUserID_Throws_InternalServerError() throws {
        // Create a request with invalid userID
        let randomUUID = UUID()
        let request = FFCreateLinkTokenRequestBody(userID: randomUUID)
        
        try app.test(.POST, "api/plaid/create-link-token", beforeRequest: { req in
            try req.content.encode(request)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .internalServerError)
        })
    }
}
