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

    // MARK: - func register(_ req: Request)
    /// Test valid registration succeeds
    func testRegisterSuccess() throws {
        let user = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let loginResponse = try res.content.decode(LoginResponse.self)
            // Assert login response matches expected
            XCTAssertEqual(loginResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(loginResponse.user.lastName, testUserLastName)
            XCTAssertEqual(loginResponse.user.email, testUserEmail)
            
            // Assert tokens are generated
            XCTAssertFalse(loginResponse.accessToken.token.isEmpty)
            XCTAssertFalse(loginResponse.refreshToken.token.isEmpty)
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
        let registerRequest = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
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
            
            // Assert tokens are generated
            XCTAssertFalse(loginResponse.accessToken.token.isEmpty)
            XCTAssertFalse(loginResponse.refreshToken.token.isEmpty)
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
    func testLoginNonExistentEmail() throws {
        let loginRequest = LoginRequest(email: "non-existent@example.com", password: testUserPassword)
        // Make a login request with a non-existent email.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }

    // Test for an Unauthorized error due to incorrect password.
    func testLoginErrorIncorrectPassword() throws {
        let loginRequest = LoginRequest(email: testUserEmail, password: "incorrectPassword")
        // Make a login request with a correct email but incorrect password.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
    
    // MARK: - func refreshAccessToken(_ req: Request)
    /// Verify the token is refreshed when it's valid.
    func testRefreshAccessTokenWithValidToken() async throws {
        // Register the user first
        let registerRequest = RegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: RefreshTokenDTO?
        var userDTO: UserDTO?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let loginResponse = try res.content.decode(LoginResponse.self)
            XCTAssertEqual(loginResponse.user.firstName, testUserFirstName)
            XCTAssertEqual(loginResponse.user.lastName, testUserLastName)
            XCTAssertEqual(loginResponse.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = loginResponse.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = loginResponse.user
            XCTAssertNotNil(userDTO)
        })
        
        let refreshToken = refreshTokenDTO!.token
        XCTAssertNotNil(refreshToken)

        // Refresh the token
        try app.test(.POST, "auth/refresh", headers: ["Authorization": "Bearer \(refreshToken)"], afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let accessTokenDTO = try res.content.decode(AccessTokenDTO.self)
            // Assert accessTokenDTO matches expected
            XCTAssertFalse(accessTokenDTO.token.isEmpty)
            // Assert UserID matches
            XCTAssertEqual(accessTokenDTO.userID, userDTO!.id)
        })
    }

    /// Verify that an invalidToken throws 401
    func testRefreshAccessTokenWithInvalidToken() async throws {
        let invalidToken = "invalidToken"
        
        try app.test(.POST, "auth/refresh", headers: ["Authorization": "Bearer \(invalidToken)"], afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }

    /// Verify that no token in request throws 401
    func testRefreshAccessTokenWithNoToken() async throws {
        try app.test(.POST, "auth/refresh", afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
}
