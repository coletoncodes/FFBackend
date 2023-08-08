//
//  File.swift
//  
//
//  Created by Coleton Gorecke on 8/7/23.
//

import Foundation

public protocol FFMonthlyBudgetNetworkService {
    func getMonthlyBudget(monthlyBudgetID: UUID) async throws -> FFMonthlyBudgetResponse
    func postMonthlyBudget(body: FFPostMonthlyBudgetRequestBody) async throws
}

public final class FFMonthlyBudgetNetworkingService: FFMonthlyBudgetNetworkService, FFNetworkService {
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
    
    public func getMonthlyBudget(monthlyBudgetID: UUID) async throws -> FFMonthlyBudgetResponse {
        return try await performRequest(
            FFGetMonthlyBudgetRequest(
                monthlyBudgetID: monthlyBudgetID,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
    
    public func postMonthlyBudget(body: FFPostMonthlyBudgetRequestBody) async throws {
        return try await performRequest(
            FFPostMonthlyBudgetRequest(
                body: body,
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )
    }
}
