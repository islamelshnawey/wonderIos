//
//  WithdrawlMoneyManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/16/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK



class WithdrawlMoneyManager{
    
    func withdrawlMoney(params:[String:Any],completionBlock :@escaping (_ Success: WithdrawlMoneyModal.WithdrawlMoney_SuccessModal?, _ AuthError: WithdrawlMoneyModal.WithdrawlMoney_ErrorModal?, Error?)->()){
        
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        let url = "http://localhost:8012/wowonder/api/withdraw"
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
            guard let result = try? JSONDecoder().decode(WithdrawlMoneyModal.WithdrawlMoney_SuccessModal.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
                    guard let result = try? JSONDecoder().decode(WithdrawlMoneyModal.WithdrawlMoney_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
    }
    
    
}

}

