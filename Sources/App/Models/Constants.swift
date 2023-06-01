//
//  Constants.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

import Foundation

@frozen enum Constants: String {
    // TODO: Update with real URL
    case baseURL = "https://financeflow-api.herokuapp.com/"
    
    // TODO: Convert to non sandbox, eventually.
    case plaidBaseURL = "https://sandbox.plaid.com/link/token/create"
}
