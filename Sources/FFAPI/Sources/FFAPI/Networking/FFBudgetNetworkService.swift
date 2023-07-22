//
//  FFBudgetNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public protocol FFBudgetNetworkService {
    func getBudget(
        userID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> FFBudgetResponse
    
    func postBudget(
        body: FFPostBudgetRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> FFBudgetResponse
    
    func deleteBudgetCategory(
        body: FFDeleteBudgetCategoryRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws
}

public final class FFBudgetNetworkingService: FFBudgetNetworkService, FFNetworkService {
    // MARK: - Initializer
    public init() {}
    
    public func getBudget(
        userID: UUID,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> FFBudgetResponse {
        return try await performRequest(
            FFGetBudgetRequest(
                userID: userID,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func postBudget(
        body: FFPostBudgetRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> FFBudgetResponse {
        return try await performRequest(
            FFPostBudgetRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func deleteBudgetCategory(
        body: FFDeleteBudgetCategoryRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws {
        return try await performRequest(
            FFDeleteBudgetCategoryRequest(
                body: body,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
}
