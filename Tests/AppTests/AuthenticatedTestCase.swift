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
    
    var authHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        let accessToken = sessionResponse.sessionDTO.accessToken.token
        headers.add(name: .authorization, value: "Bearer \(accessToken)")
        let refreshToken = sessionResponse.sessionDTO.refreshToken.token
        headers.add(name: "x-refresh-token", value: refreshToken)
        return headers
    }
    
    func testRegisterValidTestUser() throws {
        XCTAssertNoThrow(try registerValidTestUser())
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
            XCTAssertEqual(sessionResponse.userDTO.firstName, testUserFirstName)
            XCTAssertEqual(sessionResponse.userDTO.lastName, testUserLastName)
            XCTAssertEqual(sessionResponse.userDTO.email, testUserEmail)
            
            // Assert tokens are generated
            XCTAssertFalse(sessionResponse.sessionDTO.accessToken.token.isEmpty)
            XCTAssertFalse(sessionResponse.sessionDTO.refreshToken.token.isEmpty)
        })
    }
}
