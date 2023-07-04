//
//  File.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public protocol FFInstitutionsNetworkService {
    func getInstitutions(refreshToken: FFRefreshToken,
                         accessToken: FFAccessToken,
                         userID: UUID) async throws -> [FFInstitution]
}

public final class FFInstitutionsNetworkingService: FFInstitutionsNetworkService, FFNetworkService {

    // MARK: - Initializer
    public init() { }
    
    // MARK: - Interace
    public func getInstitutions(
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken,
        userID: UUID
    ) async throws -> [FFInstitution] {
        return try await performRequest(
            FFGetInstitutionsRequest(
                refreshToken: refreshToken,
                accessToken: accessToken,
                userID: userID
            )
        )
    }
}
