//
//  LinkSuccessRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Vapor

struct LinkSuccessRequest: Content {
    let userID: UUID
    let publicToken: String
    let metadata: PlaidSuccessMetadata
}

struct PlaidSuccessMetadata: Content {
    let institution: PlaidInstitution
    
    /// The accounts that were linked by the user.
    let accounts: [PlaidAccount]
}

struct PlaidInstitution: Content {
    /// The identifier of an institution, such as `ins_100000`.
    let id: String
    
    /// The full institution name, such as 'Bank of America'.
    let name: String
}

struct PlaidAccount: Content {
    let id: String
    let name: String
    let subtype: String
}
