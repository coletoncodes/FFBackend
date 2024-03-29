//
//  PlaidTransactionSyncResponse.swift
//  
//
//  Created by Coleton Gorecke on 8/12/23.
//

import Foundation

struct PlaidTransactionSyncResponse: Codable {
    struct Transaction: Codable {
        let account_id: String
        let amount: Double
        let date: String
        let name: String
        let pending: Bool
    }

    struct RemovedTransaction: Codable {
        let transaction_id: String
    }

    let added: [Transaction]
    let modified: [Transaction]
    let removed: [RemovedTransaction]
    let next_cursor: String
    let has_more: Bool
    let request_id: String
}
