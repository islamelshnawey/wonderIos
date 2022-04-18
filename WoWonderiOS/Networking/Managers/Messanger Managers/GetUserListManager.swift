

import Foundation
import Alamofire
import WoWonderTimelineSDK
class GetUserListManager{
    
    static let instance = GetUserListManager()
    var result1:GetUserListModel.AgoraCallData?
    var result2:GetUserListModel.TwilloVideoCallData?
    var result3:GetUserListModel.TwilloVideoCallData?
    
    func getUserList(user_id: String, session_Token: String, completionBlock: @escaping (_ Success:[String:Any]?,_ RoomName:String?,_ Call_Id:String?,_ senderName:String?,_ profileImage:String?,_ type:String?,_ accessToken2:String?,_ AuthError:GetUserListModel.GetUserListErrorModel?,_ ServerKeyError:GetUserListModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let params = [
           // API.Params.data_type : "users",
//            API.Params.session_token : session_Token,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
         log.verbose("API = \(API.GetUserList_Constants_Methods.GET_USER_LIST_API)")
        AF.request(API.GetUserList_Constants_Methods.GET_USER_LIST_API+session_Token, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            print(params)
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(GetUserListModel.GetUserListSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.data ?? [])")
                    guard let agoraCallData = res["agora_call_data"]  as? Any else {return}
                    guard let twilloVideoCallData = res["video_call_user"]  as? Any else{return}
                    guard let twilloAudioCallData = res["audio_call_user"]  as? Any else{return}
                    
                    log.verbose("twilloVideoCallData = \(twilloVideoCallData)")
                    log.verbose("res data = \(twilloAudioCallData)")
                    if agoraCallData is [Any]{
                        log.verbose("Empty")
                    }else{
                        log.verbose("There is something")
                        let data1 = try? JSONSerialization.data(withJSONObject: res["agora_call_data"], options: [])
                        self.result1 = try? JSONDecoder().decode(GetUserListModel.AgoraCallData.self, from: data1!)
                        log.verbose("REsult 1 = \(self.result1?.data?.type ?? "")")
                        
                    };
                    if twilloVideoCallData is [Any]{
                        log.verbose("Empty")
                    }else{
                        log.verbose("There is something")
                        let data1 = try? JSONSerialization.data(withJSONObject: res["video_call_user"], options: [])
                        self.result2 = try? JSONDecoder().decode(GetUserListModel.TwilloVideoCallData.self, from: data1!)
                        log.verbose("REsult 2 Access Token = \(self.result2?.data?.roomName ?? "")")
                        
                    }
                    if twilloAudioCallData is [Any]{
                        log.verbose("Empty")
                    }else{
                        log.verbose("There is something")
                        
                        let data1 = try? JSONSerialization.data(withJSONObject: res["audio_call_user"], options: [])
                        self.result3 = try? JSONDecoder().decode(GetUserListModel.TwilloVideoCallData.self, from: data1!)
                        log.verbose("REsult 3 Access Token = \(self.result3?.name ?? "")")
                    }
                    if self.result1 != nil{
                        completionBlock(res,self.result1?.data?.roomName,self.result1?.data?.id,self.result1?.name,(self.result1?.avatar)!, self.result1?.data?.type,nil, nil, nil, nil)
                        
                    }else if self.result2 != nil{
                        completionBlock(res,self.result2?.data?.roomName,self.result2?.data?.id,self.result2?.name,(self.result2?.avatar)!, "video",self.result2?.data?.accessToken,nil, nil, nil)
                        
                    }else if self.result3 != nil{
                        completionBlock(res,self.result3?.data?.roomName,self.result3?.data?.id,self.result3?.name,self.result3?.avatar, "audio",self.result3?.data?.accessToken,nil, nil, nil)
                    }else{
                        completionBlock(res,nil,nil,nil, nil,nil, nil, nil,nil,nil)
                    }
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetUserListModel.GetUserListErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,nil,nil,nil,nil,nil,nil,result, nil, nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetUserListModel.ServerKeyErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,nil,nil,nil,nil,nil,nil,nil, result, nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,nil,nil,nil, nil,nil,nil, response.error)
            }
        }
        
    }
    
}
