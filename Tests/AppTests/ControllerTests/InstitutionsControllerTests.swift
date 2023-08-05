//
//  InstitutionsControllerTests.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

@testable import App
import Factory
import FFAPI
import XCTVapor
import XCTest

final class InstitutionsControllerTests: AuthenticatedTestCase {
    // MARK: - Dependencies
    private var plaidAccessTokenStore: PlaidAccessTokenStore!
    
    // MARK: - Properties
    private var institutionsPath: String { "api/institutions/" }
    private var plaidAccessToken: PlaidAccessToken!
    
    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
        plaidAccessTokenStore = PlaidAccessTokenRepository()
        try await savePlaidAccessToken()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        plaidAccessTokenStore = nil
        plaidAccessToken = nil
    }
    
    private func savePlaidAccessToken() async throws {
        plaidAccessToken = PlaidAccessToken(id: UUID(), userID: user.id!, accessToken: UUID().uuidString)
        try await plaidAccessTokenStore.save(plaidAccessToken, on: app.db)
    }
    
    // MARK: - Helpers
    private func postInstitutions() throws -> [FFInstitution] {
        let institutions = [
            FFInstitution(id: .init(), name: "Institution 1", userID: user.id!, plaidAccessToken: plaidAccessToken.accessToken, accounts: []),
            FFInstitution(id: .init(), name: "Institution 2", userID: user.id!, plaidAccessToken: plaidAccessToken.accessToken, accounts: []),
        ]
        
        let requestBody = FFPostInstitutionsRequestBody(userID: user.id!, institutions: institutions)
        
        var postedInstitutions: [FFInstitution] = []
        try app.test(.POST, institutionsPath, headers: authHeaders, beforeRequest: { req in
            try req.content.encode(requestBody)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            /* THEN */
            let response = try res.content.decode(FFPostInstitutionsResponse.self)
            
            XCTAssertEqual(response.institutions, institutions)
            
            postedInstitutions = response.institutions
        })
        
        return postedInstitutions
    }
    
    func test_PostInstitutions_Success() throws {
        let institutions = try postInstitutions()
        XCTAssertFalse(institutions.isEmpty)
    }
    
    // MARK: - func getInstitutions()
    func test_GetInstitutions_Success() throws {
        /** Given */
        let institutions = try postInstitutions()
        
        /** When */
        let getPath = institutionsPath + "\(user.id!)"
        try app.test(.GET, getPath, headers: authHeaders, afterResponse: { res in
            /** Then */
            XCTAssertEqual(res.status, .ok)
            
            let response = try res.content.decode(FFGetInstitutionsResponse.self)
            XCTAssertEqual(response.institutions, institutions)
        })
    }
}
