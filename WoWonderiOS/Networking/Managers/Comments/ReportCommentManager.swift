//
//  ReportCommentManagewr.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/10/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK


class ReportCommentManager{
    
    func reportComment(comment_id: Int,completionBlock : @escaping (_ Success:ReportCommentModal.reportComment_SuccessModal?, _ AuthError: ReportCommentModal.reportComment_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.commentId:comment_id] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        
        AF.request(APIClient.ReportComment.reportComment + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                   guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(ReportCommentModal.reportComment_SuccessModal.self, from: data) else {return}
                   completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(ReportCommentModal.reportComment_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
            }
        }
        
    }
    
    static let sharedInstance = ReportCommentManager()
    private init() {}
    
    
}
