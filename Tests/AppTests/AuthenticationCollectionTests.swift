//
//  AuthenticationControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

@testable import App
import Fluent
import XCTVapor

final class AuthenticationControllerTests: XCTestCase {
    private var app: Application!
    private let testUserFirstName = "John"
    private let testUserLastName = "Doe"
    private let testUserEmail = "john@example.com"
    private let testUserPassword = "password"

    // MARK: - Lifecycle
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
    }

    override func tearDownWithError() throws {
        app.shutdown()
        app = nil
    }

    // MARK: - func register(_ req: Request)
    /// Test valid registration succeeds
    func testRegisterSuccess() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let loginResponse = try res.content.decode(LoginResponse.self)
            XCTAssertEqual(loginResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(loginResponse.user.lastName, testUserLastName)
            XCTAssertEqual(loginResponse.user.email, testUserEmail)
        })
    }

    /// Verify that a badRequest is thrown when the request doesn't provide a proper email.
    func testRegisterWithInvalidEmail() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: "not_an_email", password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the first name is empty.
    func testRegisterWithEmptyFirstName() throws {
        let user = RegisterRequest(firstName: "", lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the last name is empty.
    func testRegisterWithEmptyLastName() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: "", email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the password is less than 8 characters.
    func testRegisterWithInvalidPassword() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: "1234567", confirmPassword: "1234567")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }

    /// Verify that a badRequest is thrown when the request contains missmatched passwords.
    func testRegisterWithMismatchedPasswords() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: "wrong_password")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    // MARK: - func login(_ req: Request)
    /// Test for a successful login.
    func testLoginSuccess() throws {
        // Register the user first
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let loginResponse = try res.content.decode(LoginResponse.self)
            XCTAssertEqual(loginResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(loginResponse.user.lastName, testUserLastName)
            XCTAssertEqual(loginResponse.user.email, testUserEmail)
        })
        
        let loginRequest = LoginRequest(email: testUserEmail, password: testUserPassword)
        
        // Make a login request with the correct credentials.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let loginResponse = try res.content.decode(LoginResponse.self)
            
            // Assert the user details in the login response.
            XCTAssertEqual(loginResponse.user.email, testUserEmail)
            XCTAssertEqual(loginResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(loginResponse.user.lastName, testUserLastName)
        })
    }

    /// Test for a Bad Request error due to an invalid email.
    func testLoginInvalidEmail() throws {
        let loginRequest = LoginRequest(email: "invalid email", password: testUserPassword)
        // Make a login request with invalid data.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }

    // Test for an Unauthorized error due to non-existent email.
    func testUnauthorizedErrorNonExistentEmail() throws {
        let loginRequest = LoginRequest(email: "non-existent@example.com", password: testUserPassword)
        // Make a login request with a non-existent email.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }

    // Test for an Unauthorized error due to incorrect password.
    func testUnauthorizedErrorIncorrectPassword() throws {
        let loginRequest = LoginRequest(email: testUserEmail, password: "incorrectPassword")
        // Make a login request with a correct email but incorrect password.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
}
