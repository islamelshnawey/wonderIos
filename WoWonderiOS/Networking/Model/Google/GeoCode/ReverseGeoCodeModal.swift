//
//  ReverseGeoCodeModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 12/28/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Foundation

class ReverseGeoCodeModal{
    
    struct reverseGeoCode_SuccessModal{
         var results: [[String:Any]]
         var status: String
         init(json:[String:Any]) {
             let results = json["results"] as? [[String:Any]]
             let status = json["status"] as? String
             self.results = results ?? [["":""]]
             self.status = status ?? ""
         }
         
     }
    
    struct reverseGeoCode_ErrorModal {
       var error_message: String
       var results: [[String:Any]]
       var status: String
        init(json:[String:Any]) {
            let error_message = json["error_message"] as? String
            let results = json["results"] as? [[String:Any]]
            let status = json["status"] as? String
            self.error_message = error_message ?? ""
            self.results = results ?? [["":""]]
            self.status = status ?? ""
        }
    }
    
    
    
}
