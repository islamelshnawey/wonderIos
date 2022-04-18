
import Foundation
import Alamofire
import WoWonderTimelineSDK

class BLockUserManager{
    
    static let instance = BLockUserManager()
    
    //timeline
    func getBlockUsers(completionBlock :@escaping (_ Success: GetBlockuserModel.GetBlockuserSuccessModel?, _ AuthError: GetBlockuserModel.GetBlockuserErrorModel?, Error?)->()){
        let params = [
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.userId:UserData.getUSER_ID() ?? "",
            ] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.Block_User.getBlockUserApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = GetBlockuserModel.GetBlockuserSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }
                    
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetBlockuserModel.GetBlockuserErrorModel.self, from: data) else {return}
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
    
    //messenger
    func getBlockedUsers(session_Token: String, completionBlock: @escaping (_ Success:GetBlockedUsersModel.GetBlockedUsersSusscessModel?,_ AuthError:GetBlockedUsersModel.GetBlockedUsersErrorModel?,_ ServerKeyError:GetBlockedUsersModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.BlockUser_Methods.GET_BLOCKED_USERS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(GetBlockedUsersModel.GetBlockedUsersSusscessModel.self, from: data!)
                    log.debug("Success = \(result?.blockedUsers ?? [])")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetBlockedUsersModel.GetBlockedUsersErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetBlockedUsersModel.ServerKeyErrorModel.self, from: data!)
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
    
    func blockUnblockUser(session_Token: String,blockTo_userId:String,block_Action:String, completionBlock: @escaping (_ Success:BlockUnblockModel.BlockUnblockSuccessModel?,_ AuthError:BlockUnblockModel.BlockUnblockErrorModel?,_ ServerKeyError:BlockUnblockModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.user_id : blockTo_userId,
            API.Params.BlockAction : block_Action,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.BlockUser_Methods.BLOCK_UNBLOCK_USERS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(BlockUnblockModel.BlockUnblockSuccessModel.self, from: data)
                    log.debug("Success = \(result.blockStatus ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(BlockUnblockModel.BlockUnblockErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(BlockUnblockModel.ServerKeyErrorModel.self, from: data)
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
