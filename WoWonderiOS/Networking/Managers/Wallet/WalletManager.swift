
import Foundation
import Alamofire
import WoWonderTimelineSDK


class WalletManager{
    
    func sendMoney(user_id: String,amount: String,completionBlock :@escaping (_ Success: SendMoneyModal.sendMoney_SuccessModal?, _ AuthError: SendMoneyModal.sendMoney_ErrorModal?, Error?)->()){
        let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"send",APIClient.Params.userId:user_id, APIClient.Params.amount:amount]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.Wallet.walletApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
            guard let result = try? JSONDecoder().decode(SendMoneyModal.sendMoney_SuccessModal.self, from: data) else {return}
                completionBlock(result,nil,nil)
                }
                else{
            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
            guard let result = try? JSONDecoder().decode(SendMoneyModal.sendMoney_ErrorModal.self, from: data) else {return}
            completionBlock(nil,result,nil)
                }
            }
            else{
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
   func topUpMoney(user_id: String,amount: String,completionBlock :@escaping (_ Success: SendMoneyModal.sendMoney_SuccessModal?, _ AuthError: SendMoneyModal.sendMoney_ErrorModal?, Error?)->()){
       let params = [APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,APIClient.Params.type:"top_up",APIClient.Params.userId:user_id, APIClient.Params.amount:amount]
       let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
       AF.request(APIClient.Wallet.walletApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
           if response.value != nil{
               guard let res = response.value as? [String:Any] else {return}
               guard let apiStatusCode = res["api_status"] as? Any else {return}
               if apiStatusCode as? Int == 200 {
           guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else{return}
           guard let result = try? JSONDecoder().decode(SendMoneyModal.sendMoney_SuccessModal.self, from: data) else {return}
               completionBlock(result,nil,nil)
               }
               else{
           guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
           guard let result = try? JSONDecoder().decode(SendMoneyModal.sendMoney_ErrorModal.self, from: data) else {return}
           completionBlock(nil,result,nil)
               }
           }
           else{
               print(response.error?.localizedDescription)
               completionBlock(nil,nil,response.error)
           }
       }
   }
    
    static let sharedInstance = WalletManager()
    private init() {}
    
}
