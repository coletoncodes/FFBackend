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
    try configureDatabase(for: app)
    
    // Add Migrations
    addMigrations(app)
    
    // Setup leaf
    app.views.use(.leaf)
    
    // Setup JSW signer
    // TODO: Inject from environment
    app.jwt.signers.use(.hs256(key: "your-secret-key"))
    
    // Migrate database
    // TODO: Remove autoRevert
//    do {
//        try await app.autoRevert()
//    } catch {
//        app.logger.report(error: error)
//        fatalError("Failed to run autoRevert." + String(reflecting: error))
//    }
    
//    do {
//        try await app.autoMigrate()
//    } catch {
//        app.logger.report(error: error)
//        fatalError("Failed to run autoMigrate." + String(reflecting: error))
//    }
    
    // register routes
    try routes(app)
}
