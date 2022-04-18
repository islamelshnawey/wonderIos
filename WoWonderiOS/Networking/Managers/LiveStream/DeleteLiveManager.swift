//
//  DeleteLiveManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK


class DeleteLiveManager{
    
    func deleteLive(post_id:Int,completionBlock : @escaping (_ Success:DeleteLiveModal.deleteLive_SuccessModal?, _ AuthError: DeleteLiveModal.deleteLive_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"delete",APIClient.Params.postId:post_id] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let url = APIClient.Live.createLive
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteLiveModal.deleteLive_SuccessModal.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteLiveModal.deleteLive_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)

            }
        }
    }
    
    static let sharedInstance = DeleteLiveManager()
    private init() {}
    
}
