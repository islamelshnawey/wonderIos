//
//  CreateLiveManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class CreateLiveManager{
    
    func createLive(stream_name:String,completionBlock : @escaping (_ Success:CreateLiveModal.createLive_SuccessModal?, _ AuthError: CreateLiveModal.createLive_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"create","stream_name":stream_name] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let liveUrl = APIClient.Live.createLive
            
        AF.request(liveUrl + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = CreateLiveModal.createLive_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(CreateLiveModal.createLive_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = CreateLiveManager()
    private init() {}
    
}
