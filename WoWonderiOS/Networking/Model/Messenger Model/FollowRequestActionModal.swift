//
//  FollowRequestActionModal.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/18/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation

class FollowRequestActionModal{
    
    struct FollowRequest_SuccessModal:Codable {
        var api_status: Int
    }
    
    struct FollowRequest_ErrorModel : Codable {
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
