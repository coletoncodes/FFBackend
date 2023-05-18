import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Setup Database
    try configureDatabase(for: app)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}

fileprivate func configureDatabase(for app: Application) throws {
    let configuration: SQLPostgresConfiguration
    switch app.environment {
    case .testing:
        configuration = SQLPostgresConfiguration(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "financeflow_test",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    case .development:
        configuration = SQLPostgresConfiguration(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "financeflow_dev",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    case .production:
        guard
            let hostname = Environment.get("DATABASE_HOST"),
            let portString = Environment.get("DATABASE_PORT"),
            let port = Int(portString),
            let username = Environment.get("DATABASE_USERNAME"),
            let password = Environment.get("DATABASE_PASSWORD"),
            let database = Environment.get("DATABASE_NAME")
        else {
            app.logger.error("Cannot run Production locally. Set the DATABASE_URL environment variable, or use Development scheme")
            throw Abort(.internalServerError)
        }
        configuration = SQLPostgresConfiguration(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database,
            tls: .prefer(try .init(configuration: .clientDefault))
        )
    default:
        throw Abort(.internalServerError)
    }
    
    app.databases.use(.postgres(configuration: configuration), as: .psql)
}
