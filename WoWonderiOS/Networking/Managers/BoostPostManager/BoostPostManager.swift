//
//  BoostPostManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/5/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class BoostPostManager{
    
   private func boostPost(post_id:String,completionBlock : @escaping (_ Success:BoostPostModal.boostPost_SuccessModal?, _ AuthError: BoostPostModal.boostPost_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.postId:post_id, APIClient.Params.action: "boost"] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.SavePost.savePostApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                   guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(BoostPostModal.boostPost_SuccessModal.self, from: data) else {return}
                   completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(BoostPostModal.boostPost_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
            }
        }
        
    }
    
    func boostPosts(targetController: UIViewController, postId: String){
        self.boostPost(post_id: postId) { (success, authError, error) in
            if success != nil{
               targetController.view.makeToast(success?.action)
            }
            else if authError != nil{
                targetController.view.makeToast(authError?.errors?.errorText)
            }
            else if error != nil{
                targetController.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    static let sharedInstance = BoostPostManager()
    private init() {}
    
}
