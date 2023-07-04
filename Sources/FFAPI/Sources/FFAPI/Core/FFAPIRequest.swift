//
//  FFAPIRequest.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 5/21/23.
//

import Foundation

/// The protocol request objects must conform too.
public protocol FFAPIRequest {
    associatedtype Response: Decodable
    var body: Encodable? { get }
    
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [FFAPIHeader] { get }
    
    func urlRequest(with body: Data?) throws -> URLRequest
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension FFAPIRequest {
    
    func urlRequest(with body: Data? = nil) throws -> URLRequest {
        let urlString = FFAPIConstants.baseURLString + path
        guard let url = URL(string: urlString) else {
            let logStr = "Failed to build url from: \(urlString)"
            log(logStr, .error)
            throw FFAPIError.invalidURL(details: logStr)
        }
        
        print("URL: \(urlString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print("HTTPMethod: \(method.rawValue)")
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        print("Headers")
        headers.forEach { header in
            print("Key: \(header.key), value: \(header.value)")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
