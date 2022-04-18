//
//  CreateLiveModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation


class CreateLiveModal{
    
    struct createLive_SuccessModal{
        var api_status: Int
        var post_data: [String:Any]
        init(json:[String:Any]) {
           let api_status = json["api_status"] as? Int
           let post_data = json["post_data"] as? [String:Any]
            self.api_status = api_status ?? 0
            self.post_data = post_data ?? ["abc" : "abc"]
        }
    }
    
    struct createLive_ErrorModal:Codable {
        let apiStatus: String?
        let errors: Errors?
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case errors
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID: Int
        let errorText: String
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
    
}
