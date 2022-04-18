//
//  CheckLiveCommentModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class CheckLiveCommentModal{
    
    struct checkComments_SuccessModal {
        var api_status: Int
        var comments: [[String:Any]]
        var still_live: String
        
        init(json:[String:Any]) {
           let api_status = json["api_status"] as? Int
           let isLive = json["still_live"] as? String
           let comments = json["comments"] as? [[String:Any]]
            self.api_status = api_status ?? 0
            self.comments = comments ?? [["abc" : "abc"]]
            self.still_live = isLive ?? ""
        }
    }
    
    
    
        struct checkComments_ErrorModal:Codable{
            let apiStatus: String
            let errors: Errors
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
