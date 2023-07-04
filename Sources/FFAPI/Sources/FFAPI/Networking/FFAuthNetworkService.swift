//
//  FFAuthNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFAuthNetworkService: FFNetworkService {
    func registerUser(body: FFRegisterRequest) async throws -> FFSessionResponse
    func loginUser(body: FFLoginRequest) async throws -> FFSessionResponse
    func logout(_ user: FFUser) async throws
    func loadSession(with refreshToken: FFRefreshToken, accessToken: FFAccessToken) async throws -> FFSessionResponse
}

public final class FFAuthenticationNetworkService: FFAuthNetworkService {
    public func registerUser(body: FFRegisterRequest) async throws -> FFSessionResponse {
        return try await performRequest(RegisterUserRequest(body: body))
    }
    
    public func loginUser(body: FFLoginRequest) async throws -> FFSessionResponse {
        return try await performRequest(LoginUserRequest(body: body))
    }
    
    public func logout(_ user: FFUser) async throws {
        guard let userID = user.id else {
            throw FFAPIError.nilValue(details: "Unable to logout user, user id is nil")
        }
        return try await performRequest(FFLogoutRequest(userID: userID))
    }
        
    public func loadSession(with refreshToken: FFRefreshToken, accessToken: FFAccessToken) async throws -> FFSessionResponse {
        return try await performRequest(FFLoadSessionRequest(refreshToken: refreshToken, accessToken: accessToken))
    }
}
