//
//  FFAccessToken.swift
//  
//
//  Created by Coleton Gorecke on 7/3/23.
//

import Foundation

public struct FFAccessToken: Codable {
    public let token: String
    public let userID: UUID
    
    public init(
        token: String,
        userID: UUID
    ) {
        self.token = token
        self.userID = userID
    }
}

// TODO: Move to FFBackend
//extension FFAccessToken {
//        init(token: String, payload: JWTTokenPayload) {
//            self.init(
//                token: token,
//                userID: payload.userID
//            )
//        }
//}
//
// TODO: Move to FFBackend
//struct JWTTokenPayload: JWTPayload, Authenticatable {
//    let expiration: ExpirationClaim
//    let userID: User.IDValue
//
//    func verify(using signer: JWTSigner) throws {
//        try expiration.verifyNotExpired()
//    }
//}
