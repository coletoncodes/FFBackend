//
//  ProtectedRoutes.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import Vapor

// MARK: - ProtectedRoutes
final class ProtectedRoutes {
    let app: Application
    
    func routes() throws {
        try app.group("api") { api in
            let protectedRoutes = api.grouped(AuthenticationMiddleware())
            try protectedRoutes.register(collection: UserController())
            try protectedRoutes.register(collection: PlaidController())
        }
    }
}
