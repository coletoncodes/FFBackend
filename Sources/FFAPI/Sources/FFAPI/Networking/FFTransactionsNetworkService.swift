//
//  FFTransactionsNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/13/23.
//

import Foundation

public protocol FFTransactionsNetworkService {
    func getTransactions(
        budgetItemID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFGetTransactionsResponse
    
    func postTransactions(
        body: FFPostTransactionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFPostTransactionsResponse
    
    func deleteTransaction(
        body: FFDeleteTransactionRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFDeleteTransactionResponse
}

public final class FFTransactionsNetworkingService: FFTransactionsNetworkService, FFNetworkService {
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Interace
    public func getTransactions(
        budgetItemID: UUID,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFGetTransactionsResponse {
        return try await performRequest(
            FFGetTransactionsRequest(
                budgetItemID: budgetItemID,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
    
    public func postTransactions(
        body: FFPostTransactionsRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFPostTransactionsResponse {
        return try await performRequest(
            FFPostTransactionsRequest(
                body: body,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
    
    public func deleteTransaction(
        body: FFDeleteTransactionRequestBody,
        refreshToken: FFRefreshToken,
        accessToken: FFAccessToken
    ) async throws -> FFDeleteTransactionResponse {
        return try await performRequest(
            FFDeleteTransactionRequest(
                body: body,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
}
