//
//  AddCommentReactionManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 10/15/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK
class AddCommentReactionManager{
    
    func AddComment(commentId:Int,reaction:String,completionBlock : @escaping (_ Success:AddCommentReactionModal.AddCommentReaction_SuccessModal?, _ AuthError : AddCommentReactionModal.AddCommentReaction_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"reaction_comment",APIClient.Params.commentId:commentId,APIClient.Params.reactions:reaction] as [String : Any]
        
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"

        
        AF.request(APIClient.LikeComment.likeComment + access_token, method: .post, parameters: params, encoding:  URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                 guard let apiStatusCode = res["api_status"]  as? Any else {return}
                 let apiCode = apiStatusCode as? Int
                 if apiCode == 200 {
                  guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(AddCommentReactionModal.AddCommentReaction_SuccessModal.self, from: data)else {return}
               completionBlock(result,nil,nil)
                }
                 else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(AddCommentReactionModal.AddCommentReaction_ErrorModal.self, from: data)else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstacne = AddCommentReactionManager()
    private init() {}
    
    
}
