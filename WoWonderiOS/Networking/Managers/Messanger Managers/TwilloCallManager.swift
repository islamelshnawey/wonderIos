
import Foundation
import Alamofire
import WoWonderTimelineSDK
class TwilloCallmanager{
    
    static let instance = TwilloCallmanager()
    
    func twilloCall(user_id: String, session_Token: String,recipient_Id:String, completionBlock: @escaping (_ Success:TwilloCallModel.TwilloCallSuccessModel?,_ AuthError:TwilloCallModel.TwilloCallErrorModel?,_ ServerKeyError:TwilloCallModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.RecipientId : recipient_Id,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Twillo_Calls_Methods.TWILLO_CREATE_AUDIO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(TwilloCallModel.TwilloCallSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.roomName ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(TwilloCallModel.TwilloCallErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(TwilloCallModel.ServerKeyErrorModel.self, from: data!)
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

    func twilloAudioCallAction(user_id: String, session_Token: String,call_id:String,answer_type:String, completionBlock: @escaping (_ Success:TwilloCallActionModel.TwilloCallActionSuccessModel?,_ AuthError:TwilloCallActionModel.TwilloCallActionErrorModel?,_ ServerKeyError:TwilloCallActionModel.ServerKeyErrorModel?, Error?) ->()){
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
        AF.request(API.Twillo_Calls_Methods.TWILLO_AUDIO_CALL_ACTION_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(TwilloCallActionModel.TwilloCallActionSuccessModel.self, from: data)
                    log.debug("Success = \(result.status ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloCallActionModel.TwilloCallActionErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloCallActionModel.ServerKeyErrorModel.self, from: data)
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
    func checkForTwilloCall(user_id: String, session_Token: String,call_id:Int,call_Type:String, completionBlock: @escaping (_ Success:CheckForTwilloCallModel.CheckForTwilloCallSuccessModel?,_ AuthError:CheckForTwilloCallModel.CheckForTwilloCallErrorModel?,_ ServerKeyError:CheckForTwilloCallModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.CallId : call_id,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.CallType : call_Type
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Twillo_Calls_Methods.TWILLO_CHECK_FOR_ANSWER_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is String{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(CheckForTwilloCallModel.CheckForTwilloCallSuccessModel.self, from: data)
                    log.debug("Success = \(result.apiText ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CheckForTwilloCallModel.CheckForTwilloCallErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CheckForTwilloCallModel.ServerKeyErrorModel.self, from: data)
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
    func twilloVideoCall(user_id: String, session_Token: String,recipient_Id:String, completionBlock: @escaping (_ Success:TwilloVidooCallModel.TwilloVidooCallSuccessModel?,_ AuthError:TwilloVidooCallModel.TwilloVidooCallErrorModel?,_ ServerKeyError:TwilloVidooCallModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.session_token : session_Token,
            API.Params.RecipientId : recipient_Id,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Twillo_Calls_Methods.TWILLO_CREATE_VIDEO_CALL_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            log.verbose("Response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(TwilloVidooCallModel.TwilloVidooCallSuccessModel.self, from: data)
                    log.debug("Success = \(result.roomName ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloVidooCallModel.TwilloVidooCallErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloVidooCallModel.ServerKeyErrorModel.self, from: data)
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

    func twilloVideoCallAction(user_id: String, session_Token: String,call_id:String,answer_type:String, completionBlock: @escaping (_ Success:TwilloVideoCallActionModel.TwilloVideoCallActionSuccessModel?,_ AuthError:TwilloVideoCallActionModel.TwilloVideoCallActionErrorModel?,_ ServerKeyError:TwilloVideoCallActionModel.ServerKeyErrorModel?, Error?) ->()){
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
        AF.request(API.Twillo_Calls_Methods.TWILLO_VIDEO_CALL_ACTION_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(TwilloVideoCallActionModel.TwilloVideoCallActionSuccessModel.self, from: data)
                    log.debug("Success = \(result.status ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloVideoCallActionModel.TwilloVideoCallActionErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(TwilloVideoCallActionModel.ServerKeyErrorModel.self, from: data)
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
