//
//  FFTransactionNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 8/14/23.
//

public protocol FFTransactionNetworkService {
    func getTransactionsFor(_ institution: FFInstitution) async throws -> FFGetTransactionsResponse
}

public final class FFTransactionNetworkingService: FFTransactionNetworkService, FFNetworkService {
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
    
    public func getTransactionsFor(_ institution: FFInstitution) async throws -> FFGetTransactionsResponse {
        return try await performRequest(
            FFGetTransactionsRequest(
                institutionID: institution.id,
                plaidAccessTokenID: institution.plaidAccessTokenID,
                refreshToken: refreshToken,
                accessToken: accessToken)
        )
    }
}
