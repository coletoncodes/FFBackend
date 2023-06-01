//
//  SessionTokenDTO.swift
//  
//
//  Created by Coleton Gorecke on 5/27/23.
//

import Vapor

struct SessionDTO: Content {
    let accessToken: AccessTokenDTO
    let refreshToken: RefreshTokenDTO
    
    init(accessToken: AccessTokenDTO, refreshToken: RefreshTokenDTO) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
