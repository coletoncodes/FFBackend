//
//  JSONEncoder+.swift
//  
//
//  Created by Coleton Gorecke on 7/15/23.
//

import Foundation
import PostgresNIO

extension JSONEncoder.DateEncodingStrategy {
    static let customISO8601 = custom {
        var container = $1.singleValueContainer()
        try container.encode(CustomDateFormatter.iso8601.string(from: $0))
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let dateString = try container.decode(String.self)
        guard let date = CustomDateFormatter.iso8601.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
        }
        return date
    }
}
