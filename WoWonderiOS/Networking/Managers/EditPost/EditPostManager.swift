//
//  EditPostManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/4/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import WoWonderTimelineSDK
import Alamofire

class EditPostManager{
    
    func editPost(text: String,post_id:String,privacy:Int,completionBlock : @escaping (_ Success:EditPostModal.editPost_SuccessModal?, _ AuthError: EditPostModal.editPost_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.postId:post_id, APIClient.Params.action: "edit",APIClient.Params.text:text,APIClient.Params.postPrivacy:privacy] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.SavePost.savePostApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                   guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(EditPostModal.editPost_SuccessModal.self, from: data) else {return}
                   completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(EditPostModal.editPost_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = EditPostManager()
    private init() {}
    
}
