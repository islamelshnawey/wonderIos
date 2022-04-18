//
//  MyActivitiesModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation


class MyActivitiesModal{
    
    struct myActivites_SuccessModal {
        var api_status: Int
        var data: [[String:Any]]
        init(json:[String:Any]) {
           let api_status = json["api_status"] as? Int
           let data = json["data"] as? [[String:Any]]
            self.api_status = api_status ?? 0
            self.data = data ?? [["abc" : "abc"]]
        }
    }
    
    struct myActivties_ErrorModal:Codable{
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
