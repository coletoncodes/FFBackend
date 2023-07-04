import Fluent
import Vapor

func routes(_ app: Application) throws {
    // MARK: - Unprotected Routes
    let unprotectedRoutes = UnprotectedRoutes(app)
    try unprotectedRoutes.routes()
    
    // MARK: - Protected Routes
    let protectedRoutes = ProtectedRoutes(app)
    try protectedRoutes.routes()
    
    for route in app.routes.all {
        print(route)
    }
}
