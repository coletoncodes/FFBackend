//
//  PlaidItemDetailsResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/2/23.
//

import Foundation

struct PlaidItemDetailsResponse: Codable {
    let accounts: [PlaidAccount]
    let item: PlaidItem
    let request_id: String
}

struct PlaidAccount: Codable {
    let account_id: String
    let balances: PlaidAccountBalances
    let mask: String
    let name: String
    let official_name: String?
    let persistent_account_id: String?
    let subtype: String
    let type: String
}

struct PlaidAccountBalances: Codable {
    let available: Double?
    let current: Double
    let iso_currency_code: String
    let limit: Double?
    let unofficial_currency_code: String?
}

struct PlaidItem: Codable {
    let available_products: [String]
    let billed_products: [String]
    let consent_expiration_time: String?
    let error: String?
    let institution_id: String
    let item_id: String
    let update_type: String
    let webhook: String
}
