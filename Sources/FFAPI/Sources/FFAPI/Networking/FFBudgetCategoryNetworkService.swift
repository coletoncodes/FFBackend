//
//  FFBudgetNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public protocol FFBudgetCategoryNetworkService {
    func getCategories(monthlyBudgetID: UUID) async throws -> FFBudgetCategoriesResponse
    func saveCategories(body: FFPostBudgetCategoriesRequestBody) async throws -> FFBudgetCategoriesResponse
    func deleteCategory(categoryID: UUID) async throws
}

public final class FFBudgetCategoryNetworkingService: FFBudgetCategoryNetworkService, FFNetworkService {
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
    
    public func getCategories(monthlyBudgetID: UUID) async throws -> FFBudgetCategoriesResponse {
        return try await performRequest(
            FFGetBudgetCategoriesRequest(
                monthlyBudgetID: monthlyBudgetID,
                refreshToken: refreshToken,
                accessToken: accessToken
            )
        )
    }
    
    public func saveCategories(body: FFPostBudgetCategoriesRequestBody) async throws -> FFBudgetCategoriesResponse {
        return try await performRequest(
            FFPostBudgetCategoriesRequest(body: body, refreshToken: refreshToken, accessToken: accessToken)
        )
    }
    
    public func deleteCategory(categoryID: UUID) async throws {
        return try await performRequest(
            FFDeleteBudgetCategoryRequest(categoryID: categoryID, accessToken: accessToken, refreshToken: refreshToken)
        )
    }
}
