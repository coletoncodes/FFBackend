//
//  EndToEndTests.swift
//  FinanceFlowAPI
//
//  Created by Coleton Gorecke on 6/18/23.
//

@testable import App
import XCTVapor

final class EndToEndTests: DatabaseInteracting {
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    /// Verify we can return the JSON data from the apple-app-site-association file,
    /// and that it matches what we expect.
    func testAppleAppSiteAssociation_Success() throws {
        try app.test(.GET, ".well-known/apple-app-site-association") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.headers.contentType, .json)
            
            
            let association = try res.content.decode(AppleAppSiteAssociationResponse.self)
            
            // Check if the body data is correct.
            XCTAssertEqual(association.applinks.apps, [])
            XCTAssertEqual(association.applinks.details[0].appID, "435ZY68D35.com.cg.FinanceFlow")
            XCTAssertEqual(association.applinks.details[0].paths, ["api/plaid/redirect/*"])
        }
    }
    
}
