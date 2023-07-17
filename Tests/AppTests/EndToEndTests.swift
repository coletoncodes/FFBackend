//
//  EndToEndTests.swift
//  FinanceFlowAPI
//
//  Created by Coleton Gorecke on 6/18/23.
//

@testable import App
import FFAPI
import XCTVapor

final class EndToEndTests: DatabaseInteracting {
    private let testUserFirstName = "EndToEndFirst"
    private let testUserLastName = "EndToEndLast"
    private let testUserEmail = "endToEnd@example.com"
    private let testUserPassword = "password"
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    /// Verify the JSON data from the apple-app-site-association file is returned,
    /// and that it matches what we expect.
    func test_AppleAppSiteAssociation_Success() throws {
        try app.test(.GET, ".well-known/apple-app-site-association") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.headers.contentType, .json)
            
            
            let association = try res.content.decode(AppleAppSiteAssociationResponse.self)
            
            // Check if the body data is correct.
            XCTAssertEqual(association.applinks.apps, [])
            XCTAssertEqual(association.applinks.details[0].appID, "435ZY68D35.com.cg.FinanceFlow")
            XCTAssertEqual(association.applinks.details[0].paths, ["api/plaid/redirect/*"])
        }
    }
    
    /// Test the entire auth cycle.
    /// 1. User creates account.
    /// 2. User Log's Out.
    /// 3. User Log's In
    func test_FullAuthCycle_Success() throws {
        // 1. Create an account
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var sessionResponse: FFSessionResponse?
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            sessionResponse = try res.content.decode(FFSessionResponse.self)
            // Assert login response matches expected
            XCTAssertEqual(sessionResponse!.user.firstName, testUserFirstName)
            XCTAssertEqual(sessionResponse!.user.lastName, testUserLastName)
            XCTAssertEqual(sessionResponse!.user.email, testUserEmail)
            
            // Assert tokens are generated
            XCTAssertFalse(sessionResponse!.session.accessToken.token.isEmpty)
            XCTAssertFalse(sessionResponse!.session.refreshToken.token.isEmpty)
        })
        
        // 2. Log out
        guard let userID = sessionResponse?.user.id else {
            XCTFail("The user ID was nil and shouldn't be.")
            return
        }
        
        try app.test(.POST, "auth/logout/\(userID)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        // 3. Log in
        let loginRequest = FFLoginRequest(email: testUserEmail, password: testUserPassword)
        
        // Make a login request with the correct credentials.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let sessionResponse = try res.content.decode(FFSessionResponse.self)
            // Assert login response matches expected
            XCTAssertEqual(sessionResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(sessionResponse.user.lastName, testUserLastName)
            XCTAssertEqual(sessionResponse.user.email, testUserEmail)
            
            // Assert tokens are generated
            XCTAssertFalse(sessionResponse.session.accessToken.token.isEmpty)
            XCTAssertFalse(sessionResponse.session.refreshToken.token.isEmpty)
        })
    }
}
