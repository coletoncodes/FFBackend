//
//  Logger.swift
//  
//
//  Created by Coleton Gorecke on 7/4/23.
//

import Foundation
import OSLog

extension OSLogType {
    var emoji: String {
        switch self {
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .error:
            return "❌"
        case .fault:
            return "💥"
        default:
            return ""
        }
    }
}

/// The global logging function.
func log(
    _ message: String,
    _ osLogType: OSLogType = .debug,
    function: String = #function,
    line: Int = #line,
    file: String = #file
) {
    // set up logger
    let logger = Logger()
    let fileInfo = file.components(separatedBy: "/").last ?? "Unparsable file"
    let logInfo = "\(fileInfo), Function: \(function), Line: \(line),"
    let emojiPlusInfo = "[\(osLogType.emoji)] \(logInfo)"
    let logString = "\(emojiPlusInfo) Message: \(message)"
    
    // Switch on OSLogType
    switch osLogType {
    case .debug:
        logger.debug("\(logString)")
    case .info:
        logger.info("\(logString)")
    case .error:
        logger.error("\(logString)")
    case .fault:
        logger.fault("\(logString)")
    default:
        logger.log("\(logString)")
    }
}
