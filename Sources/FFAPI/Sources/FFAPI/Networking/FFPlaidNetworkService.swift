//
//  FFPlaidNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFPlaidNetworkService {
    func createLinkToken(body: FFCreateLinkTokenRequestBody) async throws -> FFCreateLinkTokenResponse
    func linkSuccess(body: FFLinkSuccessRequestBody) async throws
}

public final class FFPlaidNetworkingService: FFPlaidNetworkService, FFNetworkService {
    // MARK: - Properties
    private let accessToken: FFAccessToken
    private let refreshToken: FFRefreshToken
    
    // MARK: - Initializer
    public init(
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    // MARK: - Interace
    public func createLinkToken(body: FFCreateLinkTokenRequestBody) async throws -> FFCreateLinkTokenResponse {
        return try await performRequest(
            FFCreateLinkTokenRequest(body: body, refreshToken: refreshToken, accessToken: accessToken))
    }
    
    public func linkSuccess(body: FFLinkSuccessRequestBody) async throws {
        return try await performRequest(FFLinkSuccessRequest(body: body, refreshToken: refreshToken, accessToken: accessToken))
    }
}
