//
//  DeleteCommentManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/8/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import WoWonderTimelineSDK
import Alamofire

class DeleteCommentManager{
    
    func deleteComment(comment_id: Int,completionBlock : @escaping (_ Success: DeleteCommentModal.deleteComment_SuccessModal?, _ AuthError: DeleteCommentModal.deleteComment_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.commentId:comment_id, APIClient.Params.type: "delete"] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let url = APIClient.LikeComment.likeComment
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                   guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                   guard let result = try? JSONDecoder().decode(DeleteCommentModal.deleteComment_SuccessModal.self, from: data) else {return}
                   completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteCommentModal.deleteComment_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = DeleteCommentManager()
    private init() {}
    
}
