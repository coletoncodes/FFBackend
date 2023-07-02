//
//  BankAccountDTO.swift
//  
//
//  Created by Coleton Gorecke on 7/1/23.
//

import Foundation
import Vapor

struct BankAccountDTO: Content {
    let id: UUID?
    let accountID: String
    let name: String
    let subtype: String
    let institutionID: UUID
    let userID: UUID
}
