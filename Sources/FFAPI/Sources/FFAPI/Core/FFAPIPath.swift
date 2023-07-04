//
//  FFAPIPath.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 5/21/23.
//

import Foundation

enum FFAPIPath {
    /// Root Paths
    private static let auth = "auth"
    
    /// auth/register
    static let registerUser = "\(auth)/register"
    
    /// auth/login
    static let loginUser = "\(auth)/login"
    
    /// auth/logout/:userID
    static func logoutUser(_ userID: UUID) -> String {
        return "\(auth)/logout/\(userID)"
    }
    
    /// auth/refresh
    static let refreshSession = "\(auth)/refresh"
    
    /// auth/load-session
    static let loadSession = "\(auth)/load-session"
    
    /// api
    static let api = "api"
    
    /// api/plaid
    static let plaid = "\(api)/plaid"
    
    /// api/plaid/create-link-token
    static let createLinkToken = "\(plaid)/create-link-token"
    
    /// api/plaid/link-success
    static let linkSuccess = "\(plaid)/link-success"
}
