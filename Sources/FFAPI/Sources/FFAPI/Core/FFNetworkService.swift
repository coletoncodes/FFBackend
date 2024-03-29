//
//  FFNetworkService.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 5/21/23.
//

import Foundation

protocol FFNetworkService {
    func performRequest<U: FFAPIRequest>(_ request: U) async throws
    func performRequest<T: Decodable, U: FFAPIRequest>(_ request: U) async throws -> T
}

extension FFNetworkService {
    /// The standard encoder.
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        return encoder
    }
    
    /// The standard decoder.
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func performRequest<U: FFAPIRequest>(_ request: U) async throws {
        var data: Data? = nil
        if let body = request.body {
            data = try encodeBody(body)
            guard let encodedData = data, let jsonString = String(data: encodedData, encoding: .utf8) else {
                throw FFAPIError.encodingError(details: "Failed to encode body Data")
            }
            
            print("JSON: \(jsonString)")
        }
        
        let (responseData, response) = try await URLSession.shared.data(for: request.urlRequest(with: data))
        try handle(response, data: responseData)
    }
    
    func performRequest<T: Decodable, U: FFAPIRequest>(_ request: U) async throws -> T {
        var data: Data? = nil
        if let body = request.body {
            data = try encodeBody(body)
            guard let encodedData = data, let jsonString = String(data: encodedData, encoding: .utf8) else {
                throw FFAPIError.encodingError(details: "Failed to encode body Data")
            }
            
            print("JSON: \(jsonString)")
        }
        
        let (responseData, response) = try await URLSession.shared.data(for: request.urlRequest(with: data))
        try handle(response, data: responseData)
        
        let decodedResponse = try decoder.decode(T.self, from: responseData)
        
        return decodedResponse
    }
    
    // MARK: - Helpers
    private func encodeBody<T: Encodable>(_ body: T) throws -> Data {
        return try encoder.encode(body)
    }
    
    private func handle(_ response: URLResponse, data: Data) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                print("Status Code: \(httpResponse.statusCode)")
            default:
                let logStr = "Received status code: \(httpResponse.statusCode)"
                log(logStr, .error)
                let errorResponse = try decoder.decode(FFErrorResponse.self, from: data)
                throw FFAPIError.httpError(details: errorResponse)
            }
        } else {
            log("Failed to cast response as HTTPURLResponse", .error)
            throw FFAPIError.unknown(details: "Failed to cast response as HTTPURLResponse. Response: \(response)")
        }
    }
}
