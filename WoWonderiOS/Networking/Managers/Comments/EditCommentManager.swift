//
//  EditCommentManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/1/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK


class EditCommentManager{
    
    func editComment(comment_id: Int,text: String,completionBlock : @escaping (_ Success:EditCommentModal.editComment_SuccessModal?, _ AuthError: EditCommentModal.EditComment_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.commentId:comment_id, APIClient.Params.type: "edit",APIClient.Params.text:text] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let url = APIClient.LikeComment.likeComment
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                   guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                   guard let result = try? JSONDecoder().decode(EditCommentModal.editComment_SuccessModal.self, from: data) else {return}
                   completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(EditCommentModal.EditComment_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
            }
        }
    
    }
    
    static let sharedInstance = EditCommentManager()
    private init() {}
}
