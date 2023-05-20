import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    //    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Setup Database
    try configureDatabase(for: app)
    
    // Add Migrations
    addMigrations(app)
    
    // Setup leaf
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
