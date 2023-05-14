//
//  UserControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 5/13/23.
//

@testable import App
import XCTVapor

final class UserControllerTests: XCTestCase {
    
    
    func testUserCreation() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        let user = User.Create(name: "Test User", email: "test@example.com", password: "password123", confirmPassword: "password123")
        
        try app.test(.POST, "users/create", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let returnedUser = try res.content.decode(User.self)
            XCTAssertEqual(returnedUser.name, "Test User")
            XCTAssertEqual(returnedUser.email, "test@example.com")
        })
    }
    
    // Add more tests here...
    
    
}
