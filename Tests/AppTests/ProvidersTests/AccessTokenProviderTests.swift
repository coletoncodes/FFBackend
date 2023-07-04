//
//  AccessTokenProviderTests.swift
//  
//
//  Created by Coleton Gorecke on 5/20/23.
//

@testable import App
import FFAPI
import XCTest
import JWT

final class AccessTokenProviderTests: XCTestCase {
    private var sut: AccessTokenProvider!
    
    override func setUp() {
        super.setUp()
        sut = AccessTokenProvider()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Tests
    
    // MARK: - generateAccessToken(for: user)
    /// Verify generating an access token succeeds
    func testGenerateAccessToken_Success() throws {
        let user = User(id: UUID(), firstName: "John", lastName: "Doe", email: "john@johndoe.com", passwordHash: "passwordHash")
        let userDTO = FFUser(from: user)
        
        // Generate the access token
        let accessTokenDTO = try sut.generateAccessToken(for: userDTO)
        
        // Make sure the access token is not empty
        XCTAssertFalse(accessTokenDTO.token.isEmpty, "The token should not be empty.")
        
        // Make sure the access token's payload user id matches with the user id
        XCTAssertEqual(accessTokenDTO.userID, user.id, "The user id in the token payload should match with the user id.")
    }
    
    /// Verify an error is thrown when the user.id is nil
    func testGenerateAccessToken_WithNilUserID_Fails() throws {
        let user = User(id: nil, firstName: "John", lastName: "Doe", email: "john@johndoe.com", passwordHash: "passwordHash")
        let userDTO = FFUser(from: user)
        
        // Generate the access token
        XCTAssertThrowsError(try sut.generateAccessToken(for: userDTO))
    }
    
    // MARK: - validateAccessToken(token)
    func testValidateAccessTokenSuccess() throws {
        let user = User(id: UUID(), firstName: "John", lastName: "Doe", email: "john@johndoe.com", passwordHash: "passwordHash")
        let userDTO = FFUser(from: user)
        
        // Generate the access token
        let accessTokenDTO = try sut.generateAccessToken(for: userDTO)
        
        // Validate the access token
        let tokenPayload = try sut.validateAccessToken(accessTokenDTO.token)
        
        // Make sure the validated token's user id matches with the user id
        XCTAssertEqual(tokenPayload.userID, user.id, "The user id in the validated token should match with the user id.")
    }
}
