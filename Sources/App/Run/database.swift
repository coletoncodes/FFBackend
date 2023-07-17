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
            throw Abort(.internalServerError, reason: "No DATABASE_URL was found, exiting.")
        }
        
        app.logger.log(level: .info, "Running on Database URL: \(databaseURL)")
        
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)
        
        var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)
        configuration = postgresConfig
    default:
        throw Abort(.internalServerError, reason: "Unknown error")
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
