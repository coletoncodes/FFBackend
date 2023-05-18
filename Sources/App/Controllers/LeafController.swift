//
//  LeafController.swift
//  
//
//  Created by Coleton Gorecke on 5/17/23.
//

import Fluent
import Vapor

struct LeafController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get { req async throws -> View in
            try await req.view.render("home")
        }
    }
}
