//
//  GeoCodeModal.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 12/28/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Foundation
import Alamofire


class GeoCodeManager{
    
    
    func geoCode(type:String,lat:Double,lng:Double,completionBlock :@escaping (_ Success: GeoCodesModalMap.geoCode_SuccessModal?, _ AuthError: GeoCodesModalMap.geoCode_ErrorModal?, Error?)->()){
        
        AF.request("https://maps.googleapis.com/maps/api/geocode/json?\(type)=\(lat),\(lng)&key=\(ControlSettings.googleApiKey)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                print(response.value)
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["status"] as? Any else {return}
                if apiStatusCode as? String == "OK"{
                    let result = GeoCodesModalMap.geoCode_SuccessModal.init(json: res)
                    print(result)
                    completionBlock(result,nil,nil)
                }
                else{
                    let error = GeoCodesModalMap.geoCode_ErrorModal.init(json: res)
                    print(error)
                    completionBlock(nil,error,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = GeoCodeManager()
    private init() {}
    
    
    
}
