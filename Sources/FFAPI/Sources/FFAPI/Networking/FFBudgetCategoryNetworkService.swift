//
//  FFBudgetNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation

public protocol FFBudgetCategoryNetworkService {
    func getCategories(userID: UUID) async throws -> FFBudgetCategoriesResponse
    func saveCategories(body: FFPostBudgetCategoriesRequestBody) async throws -> FFBudgetCategoriesResponse
    func deleteCategory(categoryID: UUID) async throws
}

public final class FFBudgetNetworkingService: FFBudgetCategoryNetworkService, FFNetworkService {
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
    
    public func getCategories(userID: UUID) async throws -> FFBudgetCategoriesResponse {
        // TODO: Add perform request
        fatalError()
    }
    
    public func saveCategories(body: FFPostBudgetCategoriesRequestBody) async throws -> FFBudgetCategoriesResponse {
        // TODO: Add perform request
        fatalError()
    }
    
    public func deleteCategory(categoryID: UUID) async throws {
        // TODO: Add perform request
        fatalError()
    }
}
