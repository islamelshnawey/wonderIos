//
//  SearchPostManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/8/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK

class SearchPostManager{
    
    func searchPost(type: String,id:String,text:String,completionBlock : @escaping (_ Success:SearchPostModal.searchPost_SuccessModal?, _ AuthError: SearchPostModal.searchPost_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:type,APIClient.Params.id:id,"search_query":text,APIClient.Params.limit:10] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let url = APIClient.SEARCH_FOR_POST.search_for_post
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = SearchPostModal.searchPost_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(SearchPostModal.searchPost_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    
    static let sharedInstance = SearchPostManager()
    private init () {}
    
    
}
