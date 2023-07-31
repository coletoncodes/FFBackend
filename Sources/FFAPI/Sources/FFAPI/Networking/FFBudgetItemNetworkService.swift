//
//  FFBudgetItemNetworkService.swift
//  
//
//  Created by Coleton Gorecke on 7/25/23.
//

import Foundation

public protocol FFBudgetItemNetworkService {
    func saveItem(body: FFBudgetItemRequestBody) async throws -> FFBudgetItemResponse
    func deleteItem(body: FFBudgetItemRequestBody) async throws
}

public final class FFBudgetItemNetworkingService: FFBudgetItemNetworkService, FFNetworkService {
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
    
    public func saveItem(body: FFBudgetItemRequestBody) async throws -> FFBudgetItemResponse {
        return try await performRequest(FFPostBudgetItemRequest(body: body, accessToken: accessToken, refreshToken: refreshToken))
    }
    
    public func deleteItem(body: FFBudgetItemRequestBody) async throws {
        try await performRequest(FFDeleteBudgetItemRequest(body: body, accessToken: accessToken, refreshToken: refreshToken))
    }
}
