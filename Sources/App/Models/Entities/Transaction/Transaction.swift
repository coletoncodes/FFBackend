//
//  Transaction.swift
//  
//
//  Created by Coleton Gorecke on 7/11/23.
//

import Foundation
import FFAPI
import Fluent

final class Transaction: Model {
    static var schema: String = "transactions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Parent(key: "budget_item_id")
    var budgetItem: BudgetItem
    
    @Field(key: "amount")
    var amount: Double
    
    @Field(key: "date_string")
    var dateString: String
    
    @Enum(key: "transaction_type")
    var transactionType: TransactionType
    
    init() { }
    
    init(
        id: UUID? = nil,
        name: String,
        budgetItemID: UUID,
        amount: Double,
        dateString: String,
        transactionType: TransactionType
    ) {
        self.id = id
        self.name = name
        self.$budgetItem.id = budgetItemID
        self.amount = amount
        self.dateString = dateString
        self.transactionType = transactionType
    }
    
    convenience init(from transaction: FFTransaction) {
        self.init(
            id: transaction.id,
            name: transaction.name,
            budgetItemID: transaction.budgetItemID,
            amount: transaction.amount,
            dateString: RoundedDateFormatter.toRoundedDateString(from: transaction.roundedDate.date),
            transactionType: TransactionType(from: transaction.transactionType)
        )
    }
}

// TODO: move to new file
struct RoundedDateFormatter {
    static let utcTimeZone = TimeZone(abbreviation: "UTC")!
    
    private static let databaseDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = utcTimeZone
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
    
    static func toRoundedDate(from dateString: String) throws -> RoundedDate {
        guard let utcDate = databaseDateFormatter.date(from: dateString) else {
            throw DateConversionError.failedToDetermineDate("Could not create date from string: \(dateString)")
        }
        return RoundedDate(utcDate)
    }
    
    static func toRoundedDateString(from date: Date) -> String {
        let utcDate = date.convertToUTC()
        let roundedDateString = databaseDateFormatter.string(from: utcDate)
        return roundedDateString
    }
    
    private enum DateConversionError: Error {
        case failedToDetermineDate(String)
    }
}

extension Date {
    func convertToUTC() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "UTC")!
        let utcOffset = timeZone.secondsFromGMT(for: self)
        let utcDate = calendar.date(byAdding: .second, value: -utcOffset, to: self)
        return utcDate ?? self
    }
}
