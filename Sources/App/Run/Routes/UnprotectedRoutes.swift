//
//  UnprotectedRoutes.swift
//  
//
//  Created by Coleton Gorecke on 5/30/23.
//

import NIO
import Vapor

// MARK: - UnprotectedRoutes
final class UnprotectedRoutes {
    let app: Application
    
    // MARK: - Initializer
    init(_ app: Application) {
        self.app = app
    }
    
    func routes() throws {
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
}
