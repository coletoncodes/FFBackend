//
//  FFAPIConstants.swift
//  FinanceFlow
//
//  Created by Coleton Gorecke on 5/21/23.
//

import Foundation

public struct FFAPIConstants: Codable {
    // TODO: Switch on environment
    /// The baseURL as a string.
    static var baseURLString: String {
        "http://127.0.0.1:8080/"
//        "https://financeflow-api.herokuapp.com/"
    }
}
