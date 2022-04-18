//
//  MyActivitiesManager.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/13/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import Foundation
import Alamofire
import WoWonderTimelineSDK
class MyActivitiesManager{
    
    
    func getMyActivities(offset:String,completionBlock : @escaping (_ Success:MyActivitiesModal.myActivites_SuccessModal?, _ AuthError: MyActivitiesModal.myActivties_ErrorModal? , Error?)->()){
        
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.limit:20,APIClient.Params.off_set:offset] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        let url = APIClient.MY_ACTIVITIES.My_Activities
        AF.request(url + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = MyActivitiesModal.myActivites_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(MyActivitiesModal.myActivties_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = MyActivitiesManager()
    private init() {}
}
