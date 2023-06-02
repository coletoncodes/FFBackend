//
//  migrations.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor

func addMigrations(_ app: Application) {
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreatePlaidAccessToken())
    app.migrations.add(CreatePlaidLinkToken())
    app.migrations.add(DeletePlaidLinkToken())
}
