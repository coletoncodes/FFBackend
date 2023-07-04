//
//  FFAPIHeader.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 6/11/23.
//

import Foundation

public struct FFAPIHeader: Codable, Hashable {
    let key: String
    let value: String
    
    static var contentType: FFAPIHeader {
        self.init(key: "Content-Type", value: "application/json")
    }
    
    static func auth(refreshToken: String, accessToken: String) -> [FFAPIHeader] {
        [
            self.auth(refreshToken: refreshToken),
            self.apiAuth(accessToken: accessToken)
        ]
    }
    
    static func auth(refreshToken: String) -> FFAPIHeader {
        self.init(key: "x-refresh-token", value: refreshToken)
    }
    
    static func apiAuth(accessToken: String) -> FFAPIHeader {
        self.init(key: "Authorization", value: "Bearer \(accessToken)")
    }
}
