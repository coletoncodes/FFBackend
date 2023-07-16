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
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = RoundedDateFormatter.utcTimeZone
        formatter.formatOptions = [.withFullDate]
        var container = $1.singleValueContainer()
        try container.encode(formatter.string(from: $0))
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = RoundedDateFormatter.utcTimeZone
        formatter.formatOptions = [.withFullDate]
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let utcDate = formatter.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        return utcDate
    }
}

