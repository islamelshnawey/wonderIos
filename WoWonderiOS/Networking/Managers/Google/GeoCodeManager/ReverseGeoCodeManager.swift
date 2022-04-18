//
//  ReverseGeoCodeManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 12/28/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Foundation
import Alamofire

class ReverseGeoCodeManager{
    func reverseGeoCode(address:String,completionBlock :@escaping (_ Success: ReverseGeoCodeModal.reverseGeoCode_SuccessModal?, _ AuthError: ReverseGeoCodeModal.reverseGeoCode_ErrorModal?, Error?)->()){
        var url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(ControlSettings.googleApiKey)"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                print(response.value)
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"] as? Any else {return}
                if apiStatusCode as? String == "OK"{
                    let result = ReverseGeoCodeModal.reverseGeoCode_SuccessModal.init(json: res)
                    print(result)
                    completionBlock(result,nil,nil)
                }
                else{
                    let error = ReverseGeoCodeModal.reverseGeoCode_ErrorModal.init(json: res)
                    print(error)
                    completionBlock(nil,error,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
 
    static let sharedInstance = ReverseGeoCodeManager()
    private init() {}
    
}


