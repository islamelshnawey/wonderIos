

import Foundation
import Alamofire
import WoWonderTimelineSDK


class SessionManager{
    
    static let instance = SessionManager()
    
    //timeline
    func getSession( type: String,completionBlock :@escaping (_ Success: SessionModel.SessionSuccessModel?, _ AuthError: SessionModel.SessionErrorModel?, Error?)->()){
        let params = [
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.type:type
            
            ] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.Session.getSession + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(SessionModel.SessionSuccessModel.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                    
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(SessionModel.SessionErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func deleteSession( type: String,id:String,completionBlock :@escaping (_ Success: DeleteSessionModel.DeleteSessionSuccessModel?, _ AuthError: DeleteSessionModel.DeleteSessionErrorModel?, Error?)->()){
        let params = [
            
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.type:type,
            APIClient.Params.id:id
            ] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.Session.getSession + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteSessionModel.DeleteSessionSuccessModel.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteSessionModel.DeleteSessionErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    //Messenger
    func getSession( session_Token: String,type: String,completionBlock :@escaping (_ Success:SessionModel.SessionSuccessModel?,_ AuthError:SessionModel.SessionErrorModel?,_ ServerKeyError:SessionModel.ServerKeyErrorModel?, Error?)->()){
        
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.sessionType:type
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        log.verbose("API = \(API.SESSION_API.GET_SESSIONS_API)")
        AF.request(API.SESSION_API.GET_SESSIONS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(SessionModel.SessionSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(SessionModel.SessionErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors?.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(UpdateTwoFactorModel.ServerKeyErrorModel.self, from: data!)
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
    func deleteSession(session_Token: String, type: String,id:String,completionBlock :@escaping (_ Success:DeleteSessionModel.DeleteSessionSuccessModel?,_ AuthError:DeleteSessionModel.DeleteSessionErrorModel?,_ ServerKeyError:DeleteSessionModel.ServerKeyErrorModel?, Error?)->()){
        let params = [
            
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.sessionType:type,
            API.Params.Id:id
            ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        log.verbose("API = \(API.SESSION_API.DELETE_SESSIONS_API)")
        AF.request(API.SESSION_API.DELETE_SESSIONS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(DeleteSessionModel.DeleteSessionSuccessModel.self, from: data)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteSessionModel.DeleteSessionErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors?.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteSessionModel.ServerKeyErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
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
