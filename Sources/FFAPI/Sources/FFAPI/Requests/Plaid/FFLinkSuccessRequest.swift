//
//  FFLinkSuccessRequest.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Foundation

public struct FFLinkSuccessRequest: Codable {
    public let userID: UUID
    public let publicToken: String
    public let metadata: FFPlaidSuccessMetadata
    
    public init(
        userID: UUID,
        publicToken: String,
        metadata: FFPlaidSuccessMetadata
    ) {
        self.userID = userID
        self.publicToken = publicToken
        self.metadata = metadata
    }
}

public struct FFPlaidSuccessMetadata: Codable {
    public let institution: FFPlaidInstitution
    public let accounts: [FFPlaidAccount]
    
    public init(
        institution: FFPlaidInstitution,
        accounts: [FFPlaidAccount] = []
    ) {
        self.institution = institution
        self.accounts = accounts
    }
}

public struct FFPlaidInstitution: Codable {
    public let id: String
    public let name: String
    
    public init(
        id: String,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

public struct FFPlaidAccount: Codable {
    public let id: String
    public let name: String
    public let subtype: String
    
    public init(
        id: String,
        name: String,
        subtype: String
    ) {
        self.id = id
        self.name = name
        self.subtype = subtype
    }
}
