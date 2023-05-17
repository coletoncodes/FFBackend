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
//    app.databases.use(
//        .postgres(
//            configuration:
//                    .init(
//                        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//                        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
//                        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//                        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//                        database: Environment.get("DATABASE_NAME") ?? "financeflow",
//                        tls: .prefer(try .init(configuration: .clientDefault)))
//        ), as: .psql)
    
    // Setup Database
    app.databases.use(
        .postgres(
            hostname: "localhost",
            username: "cgorecke",
            password: "",
            database: "financeflow"
        ),
        as: .psql
    )
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}