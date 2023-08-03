//
//  PlaidItemDetailsRequest.swift
//  
//
//  Created by Coleton Gorecke on 8/2/23.
//

import Foundation

/// Represents the request object for accessing Item data.
struct PlaidItemDetailsRequest: Codable {
    
    /// The access token associated with the Item data being requested for.
    let accessToken: String
    
    /// Your Plaid API secret. The secret is required and may be provided either in the PLAID-SECRET header or as part of a request body.
    let secret: String
    
    /// Your Plaid API client_id. The client_id is required and may be provided either in the PLAID-CLIENT-ID header or as part of a request body.
    let clientId: String
    
    /// An optional object to filter /accounts/balance/get results.
    /// Used to fetch the balance details of the provided accountId's.
    let options: PlaidItemOptions
    
    init(
        accessToken: String,
        plaidInstitutionAccountIds: [String]
    ) {
        self.accessToken = accessToken
        self.secret = Constants.plaidSecretKey.rawValue
        self.clientId = Constants.plaidClientId.rawValue
        let date = Date()
        let formatter = ISO8601DateFormatter()
        let currentDateISO8601 = formatter.string(from: date)
        self.options = PlaidItemOptions(accountIds: plaidInstitutionAccountIds, minLastUpdatedDatetime: currentDateISO8601)
    }
}

struct PlaidItemOptions: Codable {
    
    /// A list of account_ids to retrieve for the Item. The default value is null.
    /// Note: An error will be returned if a provided account_id is not associated with the Item.
    let accountIds: [String]
    
    /// Timestamp in ISO 8601 format (YYYY-MM-DDTHH:mm:ssZ) indicating the oldest acceptable balance when making a request to /accounts/balance/get.
    /// If the balance that is pulled for ins_128026 (Capital One) is older than the given timestamp, an INVALID_REQUEST error with the code of LAST_UPDATED_DATETIME_OUT_OF_RANGE will be returned with the most recent timestamp for the requested account contained in the response.
    /// This field is only used when the institution is ins_128026 (Capital One), in which case a value must be provided or an INVALID_REQUEST error with the code of INVALID_FIELD will be returned. For all other institutions, this field is ignored.
    ///
    /// Format: date-time
    let minLastUpdatedDatetime: String?
}
