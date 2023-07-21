//
//  Abort+.swift
//  
//
//  Created by Coleton Gorecke on 7/19/23.
//

import Vapor

extension Abort {
    init(_ status: HTTPResponseStatus, reason: String, error: Error) {
        self.init(status, reason: reason + "Error: \(String(reflecting: error))")
    }
}
