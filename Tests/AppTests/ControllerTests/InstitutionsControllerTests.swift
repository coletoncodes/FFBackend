//
//  InstitutionsControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

@testable import App
import XCTVapor
import XCTest

final class InstitutionsControllerTests: AuthenticatedTestCase {
    // MARK: - Properties
    private var institutionsPath: String { "api/institutions/\(user.id!)" }
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
//    private func postInstitutions() -> [FFInstitution] {
//
//    }
    
    // MARK: - func getInstitutions()
    func test_GetInstitutions_Success() throws {
        try app.test(.GET, institutionsPath, beforeRequest: { req in
            req.headers.add(contentsOf: authHeaders)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
}
