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
        // AutoMigrate database
        try app.autoMigrate().wait()
    case .development:
        configuration = SQLPostgresConfiguration(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "financeflow_dev",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
        // AutoMigrate database
        try app.autoMigrate().wait()
    case .production:
        guard let databaseURL = Environment.get("DATABASE_URL") else {
            app.logger.error("Cannot run Production locally. Set the DATABASE_URL environment variable, or use development scheme")
            throw Abort(.internalServerError)
        }
        configuration = try SQLPostgresConfiguration(url: databaseURL)
    default:
        throw Abort(.internalServerError)
    }
    
    app.databases.use(.postgres(configuration: configuration), as: .psql)
}
