//
//  CommentDisableManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/1/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class CommentDisableManager{
    
    func commentDisable(post_id: Int,completionBlock : @escaping (_ Success:CommentDisableModal.disableComment_SuccessModal?, _ AuthError: CommentDisableModal.disableComment_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.postId:post_id, APIClient.Params.action:"disable_comments"] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        let url = APIClient.SavePost.savePostApi
        
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
                if response.value != nil {
                    guard let res = response.value as? [String:Any] else {return}
                    guard let apiStatusCode = res["api_status"] as? Any else {return}
                    if apiStatusCode as? Int == 200{
                       guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                       guard let result = try? JSONDecoder().decode(CommentDisableModal.disableComment_SuccessModal.self, from: data) else {return}
                       completionBlock(result,nil,nil)
                    }
                    else {
                        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                        guard let result = try? JSONDecoder().decode(CommentDisableModal.disableComment_ErrorModal.self, from: data) else {return}
                        completionBlock(nil,result,nil)
                    }
                }
                else {
                      print(response.error?.localizedDescription)
                      completionBlock(nil,nil,response.error)
                }
        }
        
    }
    
    
    func disableComment(targetController: UIViewController, postId: Int){
        performUIUpdatesOnMain {
            self.commentDisable(post_id: postId) { (success, authError, error) in
                if (success != nil){
                    targetController.view.makeToast(success?.action)
                }
                else if (authError != nil){
                    targetController.view.makeToast(authError?.errors?.errorText)
                }
                else if (error != nil){
                    targetController.view.makeToast(error?.localizedDescription)
                }
            }
        }
    }
    
    static let sharedIntsance = CommentDisableManager()
    private init() {}
    
}
