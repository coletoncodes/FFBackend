//
//  database.swift
//  
//
//  Created by Coleton Gorecke on 5/19/23.
//

import Vapor
import PostgresKit

func configureDatabase(for app: Application) throws {
    let configuration: SQLPostgresConfiguration
    switch app.environment {
    case .testing, .development:
        configuration = try SQLPostgresConfiguration.developmentConfig()
    case .production:
        guard let databaseURL = Environment.get("DATABASE_URL") else {
            app.logger.error("No DATABASE_URL was found, exiting.")
            throw Abort(.internalServerError)
        }
        configuration = try SQLPostgresConfiguration(url: databaseURL)
    default:
        throw Abort(.internalServerError)
    }
    
    app.databases.use(.postgres(configuration: configuration), as: .psql)
}

extension SQLPostgresConfiguration {
    static func developmentConfig() throws -> SQLPostgresConfiguration {
        self.init(
            hostname: "localhost",
            username: "cgorecke",
            password: "",
            database: "financeflowtest",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    }
}
