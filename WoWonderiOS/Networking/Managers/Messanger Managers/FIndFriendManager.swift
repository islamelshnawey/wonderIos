

import Foundation
import Alamofire
import WoWonderTimelineSDK

class FIndFriendManager{
    static let instance = FIndFriendManager()
    func fetchFindFriends(session_Token: String,gender:String,status:Int,distance:Int,lat:Double,long:Double,limit:Int,completionBlock: @escaping (_ Success:FIndFriendModel.FIndFriendSuccessModel?,_ AuthError:FIndFriendModel.FIndFriendErrorModel?,_ ServerKeyError:FIndFriendModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.gender : gender,
            API.Params.status : status,
            API.Params.distance : distance,
            API.Params.lat : lat,
            API.Params.long : long,
            API.Params.Limit_id : limit,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.FIND_FRIENDS_API.FIND_FRIENDS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(FIndFriendModel.FIndFriendSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(FIndFriendModel.FIndFriendErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(FIndFriendModel.ServerKeyErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,response.error)
            }
        }
        
    }
}
