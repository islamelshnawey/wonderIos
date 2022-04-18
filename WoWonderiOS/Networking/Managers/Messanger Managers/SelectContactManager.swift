

import Foundation
import Alamofire
import WoWonderTimelineSDK
class SelectContactManger{
    static let instance = SelectContactManger()
    
    func getContactList(user_id: String, session_Token: String,list_type:String, completionBlock: @escaping (_ Success:SelectContactModel.SelectContactSuccessModel?,_ AuthError:SelectContactModel.SelectContactErrorModel?,_ ServerKeyError:SelectContactModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.ListType : list_type,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.SelectContact_Constants_Methods.SELECT_CONTACT_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            log.verbose("response.result.value = \(response.value)")
            if (response.value != nil){
                
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(SelectContactModel.SelectContactSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.apiStatus ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(SelectContactModel.SelectContactErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(SelectContactModel.ServerKeyErrorModel.self, from: data!)
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
