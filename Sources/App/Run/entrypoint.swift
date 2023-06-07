import Vapor
import Dispatch
import Logging

/// This extension is temporary and can be removed once Vapor gets this support.
private extension Vapor.Application {
    static let baseExecutionQueue = DispatchQueue(label: "vapor.codes.entrypoint")
    
    func runFromAsyncMainEntrypoint() async throws {
        try await withCheckedThrowingContinuation { continuation in
            Vapor.Application.baseExecutionQueue.async { [self] in
                do {
                    try self.run()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

@main
enum Entrypoint {
    static func main() async throws {
        var env: Environment
        
        if let envString = Environment.get("ENV") {
            env = .init(name: envString)
        } else {
            env = try .detect()
        }
        
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
        defer { app.shutdown() }
        
        app.logger.info("Running on Environment: \(env.name)")
        
        
        Task.detached {
            do {
                try await configure(app)
            } catch {
                fatalError("Failed to run configure at main." + String(reflecting: error))
            }
            
            do {
                try await app.runFromAsyncMainEntrypoint()
            } catch {
                fatalError("Failed to run from asyncMainEntrypoint at." + String(reflecting: error))
            }
        }
    }
}
