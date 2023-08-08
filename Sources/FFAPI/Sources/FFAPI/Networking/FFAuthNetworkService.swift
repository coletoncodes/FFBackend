//
//  FFAuthNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFAuthNetworkService {
    func registerUser(body: FFRegisterRequest) async throws -> FFSessionResponse
    func loginUser(body: FFLoginRequest) async throws -> FFSessionResponse
    func logout(_ user: FFUser) async throws
    func loadSession(with refreshToken: FFRefreshToken, accessToken: FFAccessToken) async throws -> FFSessionResponse
}

public final class FFAuthenticationNetworkService: FFAuthNetworkService, FFNetworkService {
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Interace
    public func registerUser(body: FFRegisterRequest) async throws -> FFSessionResponse {
        return try await performRequest(RegisterUserRequest(body: body))
    }
    
    public func loginUser(body: FFLoginRequest) async throws -> FFSessionResponse {
        return try await performRequest(LoginUserRequest(body: body))
    }
    
    public func logout(_ user: FFUser) async throws {
        return try await performRequest(FFLogoutRequest(userID: user.id))
    }
        
    public func loadSession(with refreshToken: FFRefreshToken, accessToken: FFAccessToken) async throws -> FFSessionResponse {
        return try await performRequest(FFLoadSessionRequest(refreshToken: refreshToken, accessToken: accessToken))
    }
}
