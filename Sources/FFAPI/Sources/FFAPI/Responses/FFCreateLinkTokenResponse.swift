//
//  FFCreateLinkTokenResponse.swift
//  
//
//  Created by Coleton Gorecke on 6/1/23.
//

import Foundation

public struct FFCreateLinkTokenResponse: Codable {
    public let linkToken: String
    
    public init(linkToken: String) {
        self.linkToken = linkToken
    }
}
