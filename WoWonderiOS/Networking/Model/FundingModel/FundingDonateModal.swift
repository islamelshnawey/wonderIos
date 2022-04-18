//
//  FundingDonateModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/29/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class FundingDonateModal{
    
    struct fundingDonate_SuccessModal:Codable{
        var apiStatus: Int
        var message: String
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case message
            
        }
        
    }
    
    struct fundingDonate_ErrorModal: Codable{
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
