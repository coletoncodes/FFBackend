//
//  LoginResponse.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

struct LoginResponse: Content {
    let user: UserDTO
    let jwtToken: JWTTokenDTO
    let refreshToken: RefreshTokenDTO
}
