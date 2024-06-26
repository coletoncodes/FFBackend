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
    
    // MARK: - Initializer
    init(_ app: Application) {
        self.app = app
    }
    
    func routes() throws {
        try app.group("api") { api in 
            let protectedRoutes = api.grouped(AuthenticationMiddleware())
            try protectedRoutes.register(collection: PlaidLinkController())
            try protectedRoutes.register(collection: InstitutionsController())
            try protectedRoutes.register(collection: MonthlyBudgetController())
            try protectedRoutes.register(collection: BudgetCategoryController())
            try protectedRoutes.register(collection: BudgetItemController())
            try protectedRoutes.register(collection: TransactionsController())
        }
    }
}
