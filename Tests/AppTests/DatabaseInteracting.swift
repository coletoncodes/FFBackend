//
//  DatabaseInteracting.swift
//  
//
//  Created by Coleton Gorecke on 5/31/23.
//

@testable import App
import Fluent
import XCTVapor

class DatabaseInteracting: XCTestCase {
    private(set) var app: Application!

    // MARK: - Lifecycle
    override func setUp() async throws {
        try await super.setUp()
        app = Application(.testing)
        try await configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.shutdown()
        app = nil
    }
}
