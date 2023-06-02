//
//  Constants.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Foundation

@frozen enum Constants: String {
    // TODO: Convert to non sandbox, eventually.
    case plaidBaseURL = "https://sandbox.plaid.com"
    
    // TODO: Move to environment
    case plaidClientId = "644d45b175067100187e30eb"
    case plaidSecretKey = "787992f3ee35e6df430a4fd1f28446"
}
