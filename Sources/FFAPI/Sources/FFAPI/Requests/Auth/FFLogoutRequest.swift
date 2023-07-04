//
//  FFLogoutRequest.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

struct FFLogoutRequest: FFAPIRequest {
    var body: Encodable? = nil
    
    typealias Response = FFLogoutResponse
    
    var method: HTTPMethod { .POST }
    
    var path: String {
        FFAPIPath.logoutUser(userID)
    }
    
    var headers: [FFAPIHeader] {
        [FFAPIHeader.contentType]
    }
    
    let userID: UUID
}
