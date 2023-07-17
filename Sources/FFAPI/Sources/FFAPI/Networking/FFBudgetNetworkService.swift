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
    
    func deleteBudgetCategory(
        body: FFDeleteBudgetCategoryRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws
    
    func getBudgetItems(
        body: FFGetBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem]
    
    func postBudgetItem(
        body: FFPostBudgetItemsRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws -> [FFBudgetItem]
    
    func deleteBudgetItem(
        body: FFDeleteBudgetItemRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws
}

public final class FFBudgetNetworkingService: FFBudgetNetworkService, FFNetworkService {
    // MARK: - Initializer
    public init() {}
    
    // MARK: - BudgetCategories
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
    
    // MARK: - BudgetItems
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
    
    public func postBudgetItem(
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
    
    public func deleteBudgetItem(
        body: FFDeleteBudgetItemRequestBody,
        accessToken: FFAccessToken,
        refreshToken: FFRefreshToken
    ) async throws {
        return try await performRequest(
            FFDeleteBudgetItemRequest(
                body: body,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
}
