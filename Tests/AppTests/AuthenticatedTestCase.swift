//
//  AuthenticatedTestCase.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

@testable import App
import Fluent
import XCTVapor

class AuthenticatedTestCase: DatabaseInteracting {
    // MARK: - Properties
    open var testUserFirstName = "John"
    open var testUserLastName = "Doe"
    open var testUserEmail = "john@example.com"
    open var testUserPassword = "password"
    
    // MARK: - LifeCycle
    override func setUp() async throws {
        try await super.setUp()
        try registerValidTestUser()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sessionResponse = nil
    }
    
    // MARK: - Interface
    private(set) var sessionResponse: SessionResponse!
    
    var accessTokenHeader: HTTPHeaders {
        // Create the headers
        var headers = HTTPHeaders()
        // Create the Access Token
        let accessToken = sessionResponse.session.accessToken.token
        // Add auth header
        headers.add(name: .authorization, value: "Bearer \(accessToken)")
        return headers
    }
    
    func registerValidTestUser() throws {
        print("Registering Valid Test User")
        let registerRequest = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            sessionResponse = try res.content.decode(SessionResponse.self)
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
