import Fluent
import Vapor
import NIO

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
    
    app.get { req async throws -> View in
        try await app.view.render("index")
    }
    
    // Serve apple-app-site-association
    app.get(".well-known", "apple-app-site-association") { req async throws -> Response in
        let fileio = req.application.fileio
        let allocator = ByteBufferAllocator()
        let eventLoop = req.eventLoop
        
        let fileHandle = try NIOFileHandle(path: req.application.directory.resourcesDirectory + "apple-app-site-association.json")
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
