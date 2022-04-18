

import Foundation
import Alamofire
import WoWonderTimelineSDK


class TwoFactorManager1 {
    
    static let instance = TwoFactorManager1()
    func verifyCode (code : String, UserID : String, completionBlock : @escaping (_ Success:TwoFactorModel.TwoFactorSuccessModel?,_ AuthError:TwoFactorModel.TwoFactorErrorModel?,_ ServerKeyError:TwoFactorModel.ServerKeyErrorModel?, Error?)->()) {
        let params = [
            
            API.Params.code : code,
            API.Params.user_id : UserID,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
         log.verbose("API = \(API.TWO_FACTOR_API.AUTHENTICATE_TWO_FACTOR_API)")
        AF.request(API.TWO_FACTOR_API.AUTHENTICATE_TWO_FACTOR_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(TwoFactorModel.TwoFactorSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(TwoFactorModel.TwoFactorErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(TwoFactorModel.ServerKeyErrorModel.self, from: data!)
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
    func updateTwoFactor (session_Token: String, completionBlock : @escaping (_ Success:UpdateTwoFactorModel.UpdateTwoFactorSuccessModel?,_ AuthError:UpdateTwoFactorModel.UpdateTwoFactorErrorModel?,_ ServerKeyError:UpdateTwoFactorModel.ServerKeyErrorModel?, Error?)->()) {
        
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
         log.verbose("API = \(API.TWO_FACTOR_API.UPDATE_TWO_FACTOR_API)")
        AF.request(API.TWO_FACTOR_API.UPDATE_TWO_FACTOR_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateTwoFactorModel.UpdateTwoFactorSuccessModel.self, from: data)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateTwoFactorModel.UpdateTwoFactorErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateTwoFactorModel.ServerKeyErrorModel.self, from: data)
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
    func updateVerifyTwoFactor ( session_Token: String,code:String,Type:String,completionBlock : @escaping (_ Success:UpdateTwoFactorModel.UpdateTwoFactorSuccessModel?,_ AuthError:UpdateTwoFactorModel.UpdateTwoFactorErrorModel?,_ ServerKeyError:UpdateTwoFactorModel.ServerKeyErrorModel?, Error?)->()) {
       
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.code:code,
            API.Params.type:Type,
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.TWO_FACTOR_API.UPDATE_TWO_FACTOR_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateTwoFactorModel.UpdateTwoFactorSuccessModel.self, from: data)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateTwoFactorModel.UpdateTwoFactorErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateTwoFactorModel.ServerKeyErrorModel.self, from: data)
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
