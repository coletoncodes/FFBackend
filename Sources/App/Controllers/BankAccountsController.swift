//
//  BankAccountsController.swift
//  
//
//  Created by Coleton Gorecke on 6/20/23.
//

import Vapor

final class BankAccountsController: RouteCollection {
    // MARK: - Dependencies
    
    // MARK: - Initializer
    
    // MARK: - RoutesBuilder
    func boot(routes: RoutesBuilder) throws {
        let institutionRoutes = routes.grouped("institution")
//        let plaidRoutes = routes.grouped("plaid")
//        plaidRoutes.post("create-link-token", use: createLinkToken)
//        plaidRoutes.post("link-success", use: linkSuccess)
    }
}

// MARK: - Public Requests
//extension InstitutionController {
//
//}
