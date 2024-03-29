//
//  CustomDateFormatter.swift
//  
//
//  Created by Coleton Gorecke on 7/16/23.
//

import Foundation

struct CustomDateFormatter {
    
    static let timeZone = TimeZone(identifier: "UTC")!
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()
    
    static func toRoundedString(from date: Date) -> String {
        return iso8601.string(from: date)
    }
    
    static func toRoundedDate(from dateString: String) throws -> Date {
        guard let isoDate = iso8601.date(from: dateString) else {
            throw DateConversionError.failedToDetermineDate("Could not create date from string: \(dateString)")
        }
        // Create a calendar to remove time components
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: isoDate)
        guard let date = calendar.date(from: components) else {
            throw DateConversionError.failedToDetermineDate("Failed to remove time components from date: \(isoDate)")
        }
        return date
    }
    
    private enum DateConversionError: Error {
        case failedToDetermineDate(String)
    }
}
