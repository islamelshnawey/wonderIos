

import Foundation
import Alamofire
import WoWonderTimelineSDK
class SettingsManager{
    
    static let instance = SettingsManager()
    
    func updateUserProfile(session_Token: String,firstname:String,lastname:String,gender:String,location:String,phone:String,website:String,school:String,facebook:String,google:String,twitter:String,youtube:String,VK:String,instagram:String, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.FirstName : firstname,
            API.Params.LastName : lastname,
            API.Params.gender :gender,
            API.Params.Address : location,
            API.Params.Phone : phone,
            API.Params.Website : website,
            API.Params.School : school ,
            API.Params.Facebook : facebook,
            API.Params.Google : google,
            API.Params.Instagram : instagram,
            API.Params.VK : VK,
            API.Params.Youtube : youtube,
            API.Params.Twitter : twitter,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data!)
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
    func updateAboutMe(session_Token: String,aboutme:String, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.About : aboutme,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
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
    func updateMyAccount(session_Token: String,email:String,username:String,gender:String, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.gender : gender,
            API.Params.Email : email,
            API.Params.Username : username,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
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
    func updatePassword(session_Token: String,currentPassword:String,newPassword:String, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.CurrentPassword : currentPassword,
            API.Params.NewPassword : newPassword,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
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
    func updateUserDataWithCandA(session_Token: String,firstname:String,lastname:String,gender:String,location:String,phone:String,website:String,school:String,facebook:String,google:String,twitter:String,youtube:String,VK:String,instagram:String,type:String,avatar_data:Data?,cover_data:Data?, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.FirstName : firstname,
            API.Params.LastName : lastname,
            API.Params.gender :gender,
            API.Params.Address : location,
            API.Params.Phone : phone,
            API.Params.Website : website,
            API.Params.School : school ,
            API.Params.Facebook : facebook,
            API.Params.Google : google,
            API.Params.Instagram : instagram,
            API.Params.VK : VK,
            API.Params.Youtube : youtube,
            API.Params.Twitter : twitter,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if type == "avatar"{
                if let data = avatar_data{
                    multipartFormData.append(data, withName: type, fileName: "avatar.jpg", mimeType: "image/png")
                }
                
            }else if type == "cover"{
                if let data = cover_data{
                    multipartFormData.append(data, withName: type, fileName: "cover.jpg", mimeType: "image/png")
                }
                
            }else{
                if let avatarData = avatar_data{
                    multipartFormData.append(avatarData, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/png")
                }
                if let coverData = cover_data{
                    multipartFormData.append(coverData, withName: "cover", fileName: "cover.jpg", mimeType: "image/png")
                }
            }
            
            
        }, to: API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            print("Succesfully uploaded")
            log.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,response.error)
            }
        })
    }
    func updateAvatarAndCover(session_Token: String,type:String,avatar_data:Data?,cover_data:Data?, completionBlock: @escaping (_ Success:UpdateAvatarAndCoverModel.UpdateAvatarAndCoverSuccessModel?,_ AuthError:UpdateAvatarAndCoverModel.UpdateAvatarAndCoverErrorModel?,_ ServerKeyError:UpdateAvatarAndCoverModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if type == "avatar"{
                if let data = avatar_data{
                    multipartFormData.append(data, withName: type, fileName: "avatar.jpg", mimeType: "image/png")
                }
                
            }else if type == "cover"{
                if let data = cover_data{
                    multipartFormData.append(data, withName: type, fileName: "cover.jpg", mimeType: "image/png")
                }
                
            }else{
                if let avatarData = avatar_data{
                    multipartFormData.append(avatarData, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/png")
                }
                if let coverData = cover_data{
                    multipartFormData.append(coverData, withName: "cover", fileName: "cover.jpg", mimeType: "image/png")
                }
            }
            
        }, to: API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            print("Succesfully uploaded")
            log.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateAvatarAndCoverModel.UpdateAvatarAndCoverSuccessModel.self, from: data)
                    log.debug("Success = \(result.apiStatus ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateAvatarAndCoverModel.UpdateAvatarAndCoverErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateAvatarAndCoverModel.ServerKeyErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,response.error)
            }
        })
    }
    func updateTwoStepVerification(session_Token: String,type: String, completionBlock: @escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.two_factor:type,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
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
    func updatePrivacy(session_Token: String,key: String,value:Int,completionBlock :@escaping (_ Success:UpdateUserDataModel1.UpdateUserDataSuccessModel?,_ AuthError:UpdateUserDataModel1.UpdateUserDataErrorModel?,_ ServerKeyError:UpdateUserDataModel1.ServerKeyErrorModel?, Error?)->()){
        let params = [
            API.Params.ServerKey:API.SERVER_KEY.Server_Key,
            key:value
            
            ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Settings_Methods.UPDATE_USER_PROFILE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.UpdateUserDataErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(UpdateUserDataModel1.ServerKeyErrorModel.self, from: data)
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
