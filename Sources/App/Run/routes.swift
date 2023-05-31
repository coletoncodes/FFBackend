import Fluent
import Vapor
import NIO

func protectedRoutes(_ app: Application) throws {
    // MARK: - Protected Routes
    try app.group("api") { api in
        let protectedRoutes = api.grouped(AuthenticationMiddleware())
        try protectedRoutes.register(collection: UserController())
        try protectedRoutes.register(collection: PlaidController())
    }
}

// MARK: - Unprotected Routes
func unprotectedRoutes(_ app: Application) throws {
    try app.register(collection: LeafController())
    try app.register(collection: AuthenticationController())
    
    // Serve apple-app-site-association
    app.get(".well-known", "apple-app-site-association") { req async throws -> Response in
        let fileio = req.application.fileio
        let allocator = ByteBufferAllocator()
        let eventLoop = req.eventLoop
        
        let filePath = req.application.directory.resourcesDirectory + "apple-app-site-association"
        let fileHandle = try NIOFileHandle(path: filePath)
        defer { try? fileHandle.close() }
        
        let fileRegion = try FileRegion(fileHandle: fileHandle)
        
        let byteBuffer = try await fileio.read(fileRegion: fileRegion, allocator: allocator, eventLoop: eventLoop).get()
        
        guard let data = byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) else {
            return Response(status: .noContent)
        }
        
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        
        return Response(status: .ok, headers: headers, body: .init(data: data))
    }
}

func routes(_ app: Application) throws {
    // MARK: - Unprotected Routes
    try app.register(collection: LeafController())
    try app.register(collection: AuthenticationController())
    
    // MARK: - Protected Routes
    try app.register(collection: PlaidController())
    
    // TODO: Add once finalized.
    //    try app.register(collection: UserController())
    
//    // Serve apple-app-site-association
//    app.get(".well-known", "apple-app-site-association") { req async throws -> Response in
//        let fileio = req.application.fileio
//        let allocator = ByteBufferAllocator()
//        let eventLoop = req.eventLoop
//
//        let filePath = req.application.directory.resourcesDirectory + "apple-app-site-association"
//        let fileHandle = try NIOFileHandle(path: filePath)
//        defer { try? fileHandle.close() }
//
//        let fileRegion = try FileRegion(fileHandle: fileHandle)
//
//        let byteBuffer = try await fileio.read(fileRegion: fileRegion, allocator: allocator, eventLoop: eventLoop).get()
//
//        guard let data = byteBuffer.getData(at: 0, length: byteBuffer.readableBytes) else {
//            return Response(status: .noContent)
//        }
//
//        var headers = HTTPHeaders()
//        headers.add(name: .contentType, value: "application/json")
//
//        return Response(status: .ok, headers: headers, body: .init(data: data))
//    }
    
    // MARK: - Protected Routes
    try app.group("api") { api in
        let protectedRoutes = api.grouped(AuthenticationMiddleware())
        try protectedRoutes.register(collection: UserController())
    }
}
