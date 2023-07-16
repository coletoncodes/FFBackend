import NIOSSL
import Fluent
import FluentPostgresDriver
import JWT
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    //    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Setup Database
    do {
        try configureDatabase(for: app)
    } catch {
        app.logger.report(error: error)
        app.logger.debug("Failed to configure database.")
    }
    
    // Add Migrations
    addMigrations(app)
    
    // Setup leaf
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
