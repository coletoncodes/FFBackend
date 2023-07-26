//
//  FFInstitutionsNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFInstitutionsNetworkService {
    func getInstitutions(userID: UUID) async throws -> FFGetInstitutionsResponse
    
    func postInstitutions(body: FFPostInstitutionsRequestBody) async throws -> FFPostInstitutionsResponse
}

public final class FFInstitutionsNetworkingService: FFInstitutionsNetworkService, FFNetworkService {
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
    public func getInstitutions(userID: UUID) async throws -> FFGetInstitutionsResponse {
        return try await performRequest(
            FFGetInstitutionsRequest(
                userID: userID,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func postInstitutions(body: FFPostInstitutionsRequestBody) async throws -> FFPostInstitutionsResponse {
        return try await performRequest(
            FFPostInstitutionsRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
}
