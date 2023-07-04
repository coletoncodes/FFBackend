//
//  FFErrorResponse.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

public struct FFErrorResponse: Decodable {
    public let error: Bool
    public let reason: String
    
    public init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}
