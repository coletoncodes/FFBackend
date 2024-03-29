//
//  FFAPIHeader.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 6/11/23.
//

import Foundation

struct FFAPIHeader: Codable, Hashable {
    let key: String
    let value: String
    
    static func apiHeaders(refreshToken: FFRefreshToken, accessToken: FFAccessToken) -> [FFAPIHeader] {
        var apiHeaders = FFAPIHeader.auth(refreshToken: refreshToken, accessToken: accessToken)
        apiHeaders.append(FFAPIHeader.contentType)
        return apiHeaders
    }
    
    static var contentType: FFAPIHeader {
        self.init(key: "Content-Type", value: "application/json")
    }
    
    static func auth(refreshToken: FFRefreshToken, accessToken: FFAccessToken) -> [FFAPIHeader] {
        [
            self.auth(refreshToken: refreshToken),
            self.apiAuth(accessToken: accessToken)
        ]
    }
    
    static private func auth(refreshToken: FFRefreshToken) -> FFAPIHeader {
        self.init(key: "x-refresh-token", value: refreshToken.token)
    }
    
    static private func apiAuth(accessToken: FFAccessToken) -> FFAPIHeader {
        self.init(key: "Authorization", value: "Bearer \(accessToken.token)")
    }
}
