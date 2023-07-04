//
//  FFPlaidNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFPlaidNetworkService {
    func createLinkToken(body: FFCreateLinkTokenRequestBody, accessToken: FFAccessToken, refreshToken: FFRefreshToken) async throws -> FFCreateLinkTokenResponse
    func linkSuccess(body: FFLinkSuccessRequestBody, accessToken: FFAccessToken, refreshToken: FFRefreshToken) async throws
}

public final class FFPlaidNetworkingService: FFPlaidNetworkService, FFNetworkService {
        
    // MARK: - Interface
    public func createLinkToken(body: FFCreateLinkTokenRequestBody, accessToken: FFAccessToken, refreshToken: FFRefreshToken) async throws -> FFCreateLinkTokenResponse {
        return try await performRequest(
            FFCreateLinkTokenRequest(body: body, refreshToken: refreshToken, accessToken: accessToken))
    }
    
    public func linkSuccess(body: FFLinkSuccessRequestBody, accessToken: FFAccessToken, refreshToken: FFRefreshToken) async throws {
        return try await performRequest(FFLinkSuccessRequest(body: body, refreshToken: refreshToken, accessToken: accessToken))
    }
}
