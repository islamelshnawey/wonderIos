//
//  AddVoteManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/10/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class AddVoteManager{
    
    func addVote(vote_id: Int,completionBlock : @escaping (_ Success:AddVoteModal.addVote_SuccessModal?, _ AuthError: AddVoteModal.addVote_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key, APIClient.Params.id:vote_id] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request("\(APIClient.AddVote.voteUPApi)\(access_token)", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = AddVoteModal.addVote_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(AddVoteModal.addVote_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
        
    }
    
    static let sharedInstance = AddVoteManager()
    private init() {}
    
}
