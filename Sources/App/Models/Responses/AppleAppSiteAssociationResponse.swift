//
//  AppleAppSiteAssociationResponse.swift
//  
//
//  Created by Coleton Gorecke on 6/18/23.
//

import Foundation

struct AppleAppSiteAssociationResponse: Codable {
    let applinks: AppLinks
    
    init(applinks: AppLinks) {
        self.applinks = applinks
    }
}

struct AppLinks: Codable {
    let apps: [String]
    let details: [AppLinkDetail]
    
    init(apps: [String], details: [AppLinkDetail]) {
        self.apps = apps
        self.details = details
    }
}

struct AppLinkDetail: Codable {
    let appID: String
    let paths: [String]
    
    init(appID: String, paths: [String]) {
        self.appID = appID
        self.paths = paths
    }
}
