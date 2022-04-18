//
//  FundingDonateManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/29/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK


class FundingDonateManager{
    
    func fundingDonate(id:Int,amount:Int,completionBlock :@escaping (_ Success: FundingDonateModal.fundingDonate_SuccessModal?, _ AuthError: FundingDonateModal.fundingDonate_ErrorModal?, Error?)->()){
        
        let params = [
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"pay",APIClient.Params.amount:amount,APIClient.Params.id:id] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.Funding.getfundingApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(FundingDonateModal.fundingDonate_SuccessModal.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(FundingDonateModal.fundingDonate_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }

    }
    
    static let sharedInstance = FundingDonateManager()
    private init() {}
    
}
