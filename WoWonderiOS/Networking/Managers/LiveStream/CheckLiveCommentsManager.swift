//
//  CheckLiveCommentsManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class CheckLiveCommentsManager{
    
    func checkComments(type:String,postId:Int,offsets:String,completionBlock : @escaping (_ Success:CheckLiveCommentModal.checkComments_SuccessModal?, _ AuthError: CheckLiveCommentModal.checkComments_ErrorModal? , Error?)->()){
//        APIClient.Params.off_set:offsets
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"check_comments",APIClient.Params.limit:10,APIClient.Params.postId:postId,"page":type] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let liveUrl = APIClient.Live.createLive
        AF.request(liveUrl + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = CheckLiveCommentModal.checkComments_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(CheckLiveCommentModal.checkComments_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
        
    }
    
    static let sharedInstance = CheckLiveCommentsManager()
    private init() {}
    
}
