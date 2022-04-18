
import Foundation
import Alamofire
import WoWonderTimelineSDK
class CallManager{
    
    static let instance = CallManager()
    
    func agoraCall(user_id: String, session_Token: String,recipient_Id:String,call_Type:String, completionBlock: @escaping (_ Success:CallModel.CallSuccessModel?,_ AuthError:CallModel.CallErrorModel?,_ ServerKeyError:CallModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.RecipientId : recipient_Id,
            API.Params.CallType : call_Type,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Calls_Methods.AGORA_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(CallModel.CallSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.roomName ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(CallModel.CallErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(CallModel.ServerKeyErrorModel.self, from: data!)
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
    
    func checkForAgoraCall(user_id: String, session_Token: String,call_id:Int,call_Type:String, completionBlock: @escaping (_ Success:CheckForAgoraCallModel.CheckForAgoraCallSuccessModel?,_ AuthError:CheckForAgoraCallModel.CheckForAgoraCallErrorModel?,_ ServerKeyError:CheckForAgoraCallModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        03
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.CallId : call_id,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Calls_Methods.AGORA_CHECK_FOR_ANSWER_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is String{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(CheckForAgoraCallModel.CheckForAgoraCallSuccessModel.self, from: data)
                    log.debug("Success = \(result.apiText ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CheckForAgoraCallModel.CheckForAgoraCallErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CheckForAgoraCallModel.ServerKeyErrorModel.self, from: data)
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
    func agoraCallAction(user_id: String, session_Token: String,call_id:String,answer_type:String, completionBlock: @escaping (_ Success:AgoraCallActionModel.AgoraCallActionSuccessModel?,_ AuthError:AgoraCallActionModel.AgoraCallActionErrorModel?,_ ServerKeyError:AgoraCallActionModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.CallId : call_id,
            API.Params.AnswerType : answer_type,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Calls_Methods.AGORA_CALL_ACTION_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(AgoraCallActionModel.AgoraCallActionSuccessModel.self, from: data)
                    log.debug("Success = \(result.status ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(AgoraCallActionModel.AgoraCallActionErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(AgoraCallActionModel.ServerKeyErrorModel.self, from: data)
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
