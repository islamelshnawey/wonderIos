//
//  EditCommentModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/1/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class EditCommentModal{

    struct editComment_SuccessModal: Codable {
        var apiStatus: Int
        var message: String
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
            
        }
    }
    
    
    struct EditComment_ErrorModal: Codable{
        
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
