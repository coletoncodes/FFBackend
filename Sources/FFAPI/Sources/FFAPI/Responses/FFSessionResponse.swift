//
//  FFSessionResponse.swift
//  
//
//  Created by Coleton Gorecke on 5/27/23.
//

import Foundation

public struct FFSessionResponse: Codable {
    public let user: FFUser
    public let session: FFSession
    
    public init(user: FFUser, session: FFSession) {
        self.user = user
        self.session = session
    }
}
