import Fluent
import Vapor
import NIO

func routes(_ app: Application) throws {
    // MARK: - Unprotected Routes
    let unprotectedRoutes = UnprotectedRoutes(app: app)
    try unprotectedRoutes.routes()
    
    // MARK: - Protected Routes
    let protectedRoutes = ProtectedRoutes(app: app)
    try protectedRoutes.routes()
}
