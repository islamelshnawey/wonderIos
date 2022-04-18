//
//  GetAllUsers.swift
//  WoWonderiOS
//
//  Created by sinpanda on 3/2/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class GetAllUsers{
    
     
    struct AllUserListSuccessModel: Codable {
        var apiStatus: Int?
        var apiText: String?
        var apiVersion: String?
        var themeUrl: String?
        var users: String?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case themeUrl = "theme_url"
            case users
        }
    }
    
    struct AllUserListErrorModel: Codable {
        var apiStatus: String?
        var apiText: String?
        var errors: Errors?

        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case errors
        }
    }
           
    // MARK: - Errors
    struct Errors: Codable {
        var errorID, errorText: String?

        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
