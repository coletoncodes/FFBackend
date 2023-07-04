//
//  AuthenticationControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

@testable import App
import FFAPI
import Fluent
import XCTVapor

final class AuthenticationControllerTests: DatabaseInteracting {
    private let testUserFirstName = "John"
    private let testUserLastName = "Doe"
    private let testUserEmail = "john@example.com"
    private let testUserPassword = "password"
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - func register(_ req: Request)
    /// Test valid registration succeeds
    func testRegisterSuccess() throws {
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
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
    
    /// Verify that a badRequest is thrown when the request doesn't provide a proper email.
    func testRegisterWithInvalidEmail() throws {
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: "not_an_email", password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the first name is empty.
    func testRegisterWithEmptyFirstName() throws {
        let registerRequest = FFRegisterRequest(firstName: "", lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the last name is empty.
    func testRegisterWithEmptyLastName() throws {
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: "", email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify a .badRequest is thrown when the password is less than 8 characters.
    func testRegisterWithInvalidPassword() throws {
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: "1234567", confirmPassword: "1234567")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    /// Verify that a badRequest is thrown when the request contains miss matched passwords.
    func testRegisterWithMismatchedPasswords() throws {
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: "wrong_password")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    // MARK: - func login(_ req: Request)
    /// Test for a successful login.
    func testLoginSuccess() throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
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
    
    /// Test for a Bad Request error due to an invalid email.
    func testLoginInvalidEmail() throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: FFRefreshToken?
        var userDTO: FFUser?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFSessionResponse.self)
            XCTAssertEqual(response.user.firstName, testUserFirstName)
            XCTAssertEqual(response.user.lastName, testUserLastName)
            XCTAssertEqual(response.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = response.session.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = response.user
            XCTAssertNotNil(userDTO)
        })
        
        // Try to login with invalid email string.
        let loginRequest = FFLoginRequest(email: "invalid email", password: testUserPassword)
        // Make a login request with invalid data.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
    
    // Test for an Unauthorized error due to non-existent email.
    func testLoginNonExistentEmail() throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: FFRefreshToken?
        var userDTO: FFUser?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFSessionResponse.self)
            XCTAssertEqual(response.user.firstName, testUserFirstName)
            XCTAssertEqual(response.user.lastName, testUserLastName)
            XCTAssertEqual(response.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = response.session.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = response.user
            XCTAssertNotNil(userDTO)
        })
        
        let loginRequest = FFLoginRequest(email: "non-existent@example.com", password: testUserPassword)
        // Make a login request with a non-existent email.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
    
    // Test for an Unauthorized error due to incorrect password.
    func testLoginErrorIncorrectPassword() throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: FFRefreshToken?
        var userDTO: FFUser?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFSessionResponse.self)
            XCTAssertEqual(response.user.firstName, testUserFirstName)
            XCTAssertEqual(response.user.lastName, testUserLastName)
            XCTAssertEqual(response.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = response.session.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = response.user
            XCTAssertNotNil(userDTO)
        })
        
        // Log in the user
        let loginRequest = FFLoginRequest(email: testUserEmail, password: "incorrectPassword")
        // Make a login request with a correct email but incorrect password.
        try app.test(.POST, "auth/login", beforeRequest: { req in
            try req.content.encode(loginRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
        
    // MARK: - func logout(_ req: Request)
    func testLogoutSuccess() async throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: FFRefreshToken?
        var userDTO: FFUser?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFSessionResponse.self)
            XCTAssertEqual(response.user.firstName, testUserFirstName)
            XCTAssertEqual(response.user.lastName, testUserLastName)
            XCTAssertEqual(response.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = response.session.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = response.user
            XCTAssertNotNil(userDTO)
        })
        
        XCTAssertNotNil(refreshTokenDTO?.token)
        
        guard let userID = userDTO?.id else {
            XCTFail("The user ID was nil and shouldn't be.")
            return
        }
        
        try app.test(.POST, "auth/logout/\(userID)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    // MARK: - func loadSession(_ req: Request)
    /// Verify the session is refreshed when it's valid.
    func testLoadSessionWithValidToken() async throws {
        // Register the user first
        let registerRequest = FFRegisterRequest(firstName: testUserFirstName, lastName: testUserLastName, email: testUserEmail, password: testUserPassword, confirmPassword: testUserPassword)
        var refreshTokenDTO: FFRefreshToken?
        var accessTokenDTO: FFAccessToken?
        var userDTO: FFUser?
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let response = try res.content.decode(FFSessionResponse.self)
            XCTAssertEqual(response.user.firstName, testUserFirstName)
            XCTAssertEqual(response.user.lastName, testUserLastName)
            XCTAssertEqual(response.user.email, testUserEmail)
            
            // Set refresh token
            refreshTokenDTO = response.session.refreshToken
            XCTAssertNotNil(refreshTokenDTO)
            
            // Set the userDTO
            userDTO = response.user
            XCTAssertNotNil(userDTO)
            
            accessTokenDTO = response.session.accessToken
            XCTAssertNotNil(accessTokenDTO)
        })
        
        guard let refreshToken = refreshTokenDTO?.token else {
            XCTFail("Nil Refresh Token was found")
            return
        }
        
        guard let accessToken = accessTokenDTO?.token else {
            XCTFail("Nil access token was found")
            return
        }
        
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        headers.add(name: "x-refresh-token", value: refreshToken)
        
        // Refresh the token
        try app.test(
            .POST, "auth/load-session",
            headers: headers,
            afterResponse: { res in
                XCTAssertEqual(res.status, .ok)
                let response = try res.content.decode(FFSessionResponse.self)
                // Assert Tokens are not empty
                XCTAssertFalse(response.session.accessToken.token.isEmpty)
                XCTAssertFalse(response.session.refreshToken.token.isEmpty)
                // Assert UserID matches
                XCTAssertEqual(response.user.id, userDTO!.id)
            })
    }
    
    /// Verify that an invalidToken throws 401
    func testLoadSessionInvalidToken() async throws {
        let invalidToken = "invalidToken"
        
        try app.test(.POST, "auth/load-session", headers: ["Authorization": "Bearer \(invalidToken)"], afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
    
    /// Verify that no token in request throws 401
    func testLoadSessionWithNoToken() async throws {
        try app.test(.POST, "auth/load-session", afterResponse: { res in
            XCTAssertEqual(res.status, .unauthorized)
        })
    }
}
