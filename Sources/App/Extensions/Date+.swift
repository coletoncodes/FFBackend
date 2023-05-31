//
//  Date+.swift
//  
//
//  Created by Coleton Gorecke on 5/27/23.
//

import Foundation

extension Date {
    static var thirtyDaysFromNow: Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 30
        return calendar.date(byAdding: dateComponents, to: .now)
    }
}
