//
//  FFAPIError.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation

enum FFAPIError: Error {
    case invalidURL(details: String)
    case httpError(details: FFErrorResponse)
    case decodingError(details: String)
    case unknown(details: String)
    case nilValue(details: String)
    
    var errorDetail: String {
        switch self {
        case .httpError(let errorResponse):
            return errorResponse.reason
        case .invalidURL(let details),
                .decodingError(let details),
                .unknown(let details),
                .nilValue(let details):
            return details
        }
    }
}
