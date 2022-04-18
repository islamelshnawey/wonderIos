//
//  GetSettingModal.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/22/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation

class GetSettingModal{
    
    struct GetSetting_SuccessModal{
        var api_status: String
        var api_text: String
        var api_version: String
        var config: [String:Any]
    }
    
    struct GetSetting_ErrorModal:Codable{
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
extension GetSettingModal.GetSetting_SuccessModal{
    
    init(json:[String:Any]) {
     let api_status = json["api_status"] as? String
     let api_text = json["api_text"] as? String
     let api_version = json["api_version"] as? String
     let config = json["config"] as? [String:Any]
        self.api_status = api_status ?? ""
        self.api_text = api_text ?? ""
        self.api_version = api_version ?? ""
        self.config = config ?? ["id":"dsakjhk"]
     }
}
