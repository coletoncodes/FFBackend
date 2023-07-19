//
//  FFInstitutionsNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFInstitutionsNetworkService {
    func getInstitutions(
        userID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> [FFInstitution]
    
    func postInstitutions(
        body: FFPostInstitutionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> [FFInstitution]
}

public final class FFInstitutionsNetworkingService: FFInstitutionsNetworkService, FFNetworkService {
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Interace
    public func getInstitutions(
        userID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> [FFInstitution] {
        return try await performRequest(
            FFGetInstitutionsRequest(
                userID: userID,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func postInstitutions(
        body: FFPostInstitutionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> [FFInstitution] {
        return try await performRequest(
            FFPostInstitutionsRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
}
