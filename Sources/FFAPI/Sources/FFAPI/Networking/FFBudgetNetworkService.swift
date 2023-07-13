//
//  FFBudgetNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public protocol FFBudgetNetworkService {
    func getBudgetCategories(
        body: FFGetBudgetCategoriesRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetCategory]
    
    func postBudgetCategories(
        body: FFPostBudgetCategoriesRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetCategory]
    
    func getBudgetItems(
        body: FFGetBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem]
    
    func postBudgetItems(
        body: FFPostBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem]
}

public final class FFBudgetNetworkingService: FFBudgetNetworkService, FFNetworkService {
    
    // MARK: - Initializer
    public init() {}
    
    // MARK: - Interface
    public func getBudgetCategories(
        body: FFGetBudgetCategoriesRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetCategory] {
        return try await performRequest(
            FFGetBudgetCategoriesRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func postBudgetCategories(
        body: FFPostBudgetCategoriesRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetCategory] {
        return try await performRequest(
            FFPostBudgetCategoriesRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func getBudgetItems(
        body: FFGetBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem] {
        return try await performRequest(
            FFGetBudgetItemsRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func postBudgetItems(
        body: FFPostBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem] {
        return try await performRequest(
            FFPostBudgetItemsRequest(
                body: body,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
}
