//
//  EditPostModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/4/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class EditPostModal{
    
    struct editPost_SuccessModal: Codable {
        var apiStatus: Int
        var action: String
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case action
            
        }
    }
    
    struct editPost_ErrorModal: Codable{
        
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
