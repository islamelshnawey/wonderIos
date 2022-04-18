

import Foundation
import Alamofire
import WoWonderTimelineSDK
class SearchManager {
    
    static let instance = SearchManager()
    func searchUser(session_Token: String,country:String,status:String,verified:String,filterByAge:String,ageFrom:String,ageTo:String,search_Key:String,gender:String,completionBlock: @escaping (_ Success:SearchModel.SearchSuccessModel?,_ AuthError:SearchModel.SearchErrorModel?,_ ServerKeyError:SearchModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.gender : gender,
            API.Params.country : gender,
            API.Params.status : gender,
            API.Params.verified : gender,
            API.Params.filterbyage : gender,
            API.Params.age_from : gender,
            API.Params.age_to : gender,
            API.Params.SearchKey : search_Key,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Search_Methods.SEARCH_USER_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(SearchModel.SearchSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.users ?? [])")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(SearchModel.SearchErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(SearchModel.ServerKeyErrorModel.self, from: data!)
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
