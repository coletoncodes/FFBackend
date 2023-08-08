//
//  FFCategoryType.swift
//  
//
//  Created by Coleton Gorecke on 7/26/23.
//

import Foundation

public enum FFCategoryType: String, Codable, Identifiable {
    case income
    case expense
    
    public var id: String {
        self.rawValue
    }
}
