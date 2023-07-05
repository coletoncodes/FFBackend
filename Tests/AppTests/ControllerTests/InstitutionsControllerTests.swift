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
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - func getInstitutions()
    func testGetInstitutionsSuccess() throws {
        let userID = user.id!
        try app.test(.GET, "api/institutions/\(userID)", beforeRequest: { req in
            req.headers.add(contentsOf: authHeaders)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
}
