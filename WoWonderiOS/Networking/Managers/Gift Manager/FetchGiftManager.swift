

import Foundation
import Alamofire
import WoWonderTimelineSDK


class FetchGiftManager{
    
    func fetchGift(offset: String,completionBlock :@escaping (_ Success: FetchGiftModal.fetchGift_SuccessModal?, _ AuthError: FetchGiftModal.fetchGift_ErrorModal?, Error?)->()){
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.limit: 10,APIClient.Params.type:"fetch",APIClient.Params.off_set:offset] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.Gift.giftApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
                    let result = FetchGiftModal.fetchGift_SuccessModal.init(json: res)
                  completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(FetchGiftModal.fetchGift_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = FetchGiftManager()
    private init() {}
}
