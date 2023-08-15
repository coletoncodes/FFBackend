//
//  FFTransactionNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 8/14/23.
//

public protocol FFTransactionNetworkService {
    func getTransactionsForInstitution(with id: FFInstitution.ID) async throws -> FFGetTransactionsResponse
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
    
    public func getTransactionsForInstitution(with id: FFInstitution.ID) async throws -> FFGetTransactionsResponse {
        return try await performRequest(
            FFGetTransactionsRequest(institutionID: id, refreshToken: refreshToken, accessToken: accessToken)
        )
    }
}
