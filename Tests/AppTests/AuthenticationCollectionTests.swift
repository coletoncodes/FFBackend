//
//  AuthenticationCollectionTests.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

@testable import App
import Fluent
import XCTVapor

final class AuthenticationCollectionTests: XCTestCase {
    private var app: Application!

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

    func testRegisterWithValidData() throws {
        let user = RegisterRequest(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password", confirmPassword: "password")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let loginResponse = try res.content.decode(LoginResponse.self)
            XCTAssertEqual(loginResponse.user.firstName, "John")
            XCTAssertEqual(loginResponse.user.lastName, "Doe")
            XCTAssertEqual(loginResponse.user.email, "john@example.com")
        })
    }

    func testRegisterWithInvalidData() throws {
        let user = RegisterRequest(firstName: "John", lastName: "Doe", email: "not_an_email", password: "password", confirmPassword: "password")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }

    func testRegisterWithMismatchedPasswords() throws {
        let user = RegisterRequest(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password", confirmPassword: "wrong_password")
        
        try app.test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
}
