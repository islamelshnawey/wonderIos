//
//  GetSettingManager.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/22/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class GetSettingManager{
   
    func getSetting (completionBlock : @escaping (_ Success: GetSettingModal.GetSetting_SuccessModal?, _ AuthError :GetSettingModal.GetSetting_ErrorModal?, Error?)->()){
        
        let params = [API.Params.user_id:AppInstance.instance.userId ?? "",API.Params.session_token:AppInstance.instance.sessionId ?? ""]
        AF.request(API.Settings_Methods.Get_SettingApi, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? String == "200"{
                    let result = GetSettingModal.GetSetting_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetSettingModal.GetSetting_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = GetSettingManager()
    private init() {}
    
    
}
