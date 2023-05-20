////
////  UserControllerTests.swift
////
////
////  Created by Coleton Gorecke on 5/13/23.
////
//
//@testable import App
//import XCTVapor
//
//final class UserControllerTests: XCTestCase {
//
//    private var user: User.Create = .init(name: "UserControllerTests User", email: "userControllerTests@test.com", password: "password", confirmPassword: "password")
//
//
//    func testEndToEndAuthFlow() async throws {
//        // Create app and make test client
//        let app = Application(.testing)
//        defer { app.shutdown() }
//        try await configure(app)
//
//        // 1. Register new user
//        try app.test(.POST, "users/create", beforeRequest: { req in
//            try req.content.encode(user)
//        }, afterResponse: { res in
//            XCTAssertEqual(res.status, .ok)
//        })
//
//        // 2. Login with new user
//        let credentials = BasicAuthorization(username: "test@test.com", password: "password")
//        var maybeToken: UserToken?
//        try app.test(.POST, "users/login", beforeRequest: { req in
//            req.headers.basicAuthorization = credentials
//        }, afterResponse: { res in
//            XCTAssertEqual(res.status, .ok)
//            let userToken = try res.content.decode(UserToken.self)
//            XCTAssertNotNil(userToken)
//            maybeToken = userToken
//        })
//
//        let token = try XCTUnwrap(maybeToken)
//
//        // 3. Access protected route with token
//        try app.test(.GET, "users", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: token.value)
//        }, afterResponse: { res in
//            XCTAssertEqual(res.status, .ok)
//        })
//
////    }
//
//
//
////    func testUserCreation() async throws {
////        let app = Application(.testing)
////        defer { app.shutdown() }
////        try await configure(app)
////
////        // Clear database before test
////        try await app.test(.DELETE, "users/clear")
////
////        let user = User.Create(name: "Test User", email: "test@example.com", password: "password123", confirmPassword: "password123")
////
////        try app.test(.POST, "users/create", beforeRequest: { req in
////            try req.content.encode(user)
////        }, afterResponse: { res in
////            XCTAssertEqual(res.status, .ok)
////            let returnedUser = try res.content.decode(User.self)
////            XCTAssertEqual(returnedUser.name, "Test User")
////            XCTAssertEqual(returnedUser.email, "test@example.com")
////        })
////    }
//
//    // Read test
////    func testUserRead() async throws {
////        let app = Application(.testing)
////        defer { app.shutdown() }
////        try await configure(app)
////
////
////        try app.test(.GET, "users/\(user.id!)") { res in
////            XCTAssertEqual(res.status, .ok)
////            let receivedUser = try res.content.decode(User.self)
////            XCTAssertEqual(receivedUser.name, user.name)
////            XCTAssertEqual(receivedUser.email, user.email)
////        }
////    }
////
////    // Update test
////    func testUserUpdate() async throws {
////        let app = Application(.testing)
////        defer { app.shutdown() }
////        try await configure(app)
////
////        let user = User(name: "Test User", email: "test@test.com", passwordHash: "password")
////        try await user.save(on: app.db).get()
////
////        let updatedUser = User(name: "Updated User", email: "updated@test.com", passwordHash: "password")
////
////        try app.test(.PUT, "users/\(user.id!)", beforeRequest: { req in
////            try req.content.encode(updatedUser)
////        }) { res in
////            XCTAssertEqual(res.status, .ok)
////            let receivedUser = try res.content.decode(User.self)
////            XCTAssertEqual(receivedUser.name, updatedUser.name)
////            XCTAssertEqual(receivedUser.email, updatedUser.email)
////        }
////    }
////
////    // Delete test
////    func testUserDelete() async throws {
////        let app = Application(.testing)
////        defer { app.shutdown() }
////        try await configure(app)
////
////        let user = User(name: "Test User", email: "test@test.com", passwordHash: "password")
////        try await user.save(on: app.db).get()
////
////        try app.test(.DELETE, "users/\(user.id!)") { res in
////            XCTAssertEqual(res.status, .noContent)
////        }
////
////        try app.test(.GET, "users/\(user.id!)") { res in
////            XCTAssertEqual(res.status, .notFound)
////        }
////    }
////
////    // Login test
////    func testUserLogin() async throws {
////        let app = Application(.testing)
////        defer { app.shutdown() }
////        try await configure(app)
////
////        let password = "password"
////        let user = User(name: "Test User", email: "test@test.com", passwordHash: try! Bcrypt.hash(password))
////        try await user.save(on: app.db).get()
////
////        let credentials = BasicAuthorization(username: user.email, password: password)
////
////        try app.test(.POST, "users/login", beforeRequest: { req in
////            req.headers.basicAuthorization = credentials
////        }) { res in
////            XCTAssertEqual(res.status, .ok)
////            let receivedToken = try res.content.decode(UserToken.self)
////            XCTAssertEqual(receivedToken.$user.id, user.id)
////        }
////    }
//}
