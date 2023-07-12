//
//  TransactionType.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import FFAPI
import Fluent

enum TransactionType: String, Codable {
    case income
    case expense
    
    init(from type: FFTransactionType) {
        switch type {
        case .expense:
            self = .expense
        case .income:
            self = .income
        }
    }
}
