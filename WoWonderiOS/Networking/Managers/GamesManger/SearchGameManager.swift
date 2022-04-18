//
//  SearchGameManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/11/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK


class SearchGameManager{
    
    func searchGame(text:String,completionBlock :@escaping (_ Success: SearchGameModal.searchGame_SuccessModal?, _ AuthError: SearchGameModal.searchGame_ErrorModal?, Error?)->()){
        let params = [
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.type:"search",APIClient.Params.limit:10,"query":text] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"

        AF.request(APIClient.Games.getGames + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = SearchGameModal.searchGame_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(SearchGameModal.searchGame_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = SearchGameManager()
    private init() {}
    
}
