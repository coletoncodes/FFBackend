//
//  PlaidGetTransactionsRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/18/23.
//

import Vapor
import Foundation

struct PlaidGetTransactionsRequest: Content {
    let client_id: String
    let secret: String
    let access_token: String
    let start_date: Date
    let end_date: Date
    let options: PlaidTransactionOptions
    
    init(
        access_token: String,
        start_date: Date,
        end_date: Date
    ) {
        self.client_id = Constants.plaidClientId.rawValue
        self.secret = Constants.plaidSecretKey.rawValue
        self.access_token = access_token
        self.start_date = start_date
        self.end_date = end_date
        self.options = PlaidTransactionOptions()
    }
}

struct PlaidTransactionOptions: Content {
    let include_personal_finance_category: Bool
    
    init() {
        self.include_personal_finance_category = true
    }
}
