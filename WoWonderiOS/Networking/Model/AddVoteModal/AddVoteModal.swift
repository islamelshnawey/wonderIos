//
//  AddVoteModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/10/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation

class AddVoteModal{
    
    struct addVote_SuccessModal{
        var api_status: Int
        var votes: [[String:Any]]
        init(json:[String:Any]) {
           let api_status = json["api_status"] as? Int
           let votes = json["votes"] as? [[String:Any]]
            self.api_status = api_status ?? 0
            self.votes = votes ?? [["abc" : "abc"]]
        }
    }
    
    
    struct addVote_ErrorModal:Codable{
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
