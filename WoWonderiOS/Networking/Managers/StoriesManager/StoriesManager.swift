

import Foundation
import Alamofire
import WoWonderTimelineSDK


class StoriesManager{
    
   static let instance = StoriesManager()
    
    //timeline
    func getUserStories(offset: Int, limit: Int,completionBlock :@escaping (_ Success: GetStoriesModel.GetStoriesSuccessModel?, _ AuthError: GetStoriesModel.GetStoriesErrorModel?, Error?)->()){
        let params = [
            
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.offset:offset,
            APIClient.Params.limit:limit,
            ] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token() ?? "")"
        AF.request(APIClient.Stories.getUserStories + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil{
                
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetStoriesModel.GetStoriesSuccessModel.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetStoriesModel.GetStoriesErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func createStory(story_data:Data?,mimeType:String,type:String,text:String, completionBlock: @escaping (_ Success:CreateStoryModel.CreateStorySuccessModel?,_ AuthError:CreateStoryModel.CreateStoryErrorModel?, Error?) ->()){
        
        let params = [
            APIClient.Params.FileType : type,
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.text:text,
           
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if type == "video"{
                if let data = story_data{
                    multipartFormData.append(data, withName: "file", fileName: "file.mp4", mimeType: mimeType)
                }
            }else if type == "image"{
                if let data = story_data{
                     multipartFormData.append(data, withName: "file", fileName: "image.jpg", mimeType: mimeType)
                }
            }
        }, to: APIClient.Stories.createStories +  "\("?")\("access_token")\("=")\(UserData.getAccess_Token() ?? "")", usingThreshold: UInt64.init(), method: .post, headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            //Do what ever you want to do with response
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                print("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus as? Int == 200{
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(CreateStoryModel.CreateStorySuccessModel.self, from: data)
                    print("Success = \(result.storyID ?? 0)")
                    completionBlock(result,nil,nil)
                }else{
                    print("apiStatus String = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(CreateStoryModel.CreateStoryErrorModel.self, from: data)
                    print("AuthError = \(result.errors!.errorText)")
                    completionBlock(nil,result,nil)

                }

            }else{
                print("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,response.error)
            }
        })
//        }, usingThreshold: UInt64.init(), to: APIClient.Stories.createStories +  "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", method: .post, headers: headers) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print("Succesfully uploaded")
//                    if (response.value != nil){
//                        guard let res = response.value as? [String:Any] else {return}
//                        print("Response = \(res)")
//                        guard let apiStatus = res["api_status"]  as? Any else {return}
//                        if apiStatus as? Int == 200{
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = try! JSONDecoder().decode(CreateStoryModel.CreateStorySuccessModel.self, from: data)
//                            print("Success = \(result.storyID ?? 0)")
//                            completionBlock(result,nil,nil)
//                        }else{
//                            print("apiStatus String = \(apiStatus)")
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = try! JSONDecoder().decode(CreateStoryModel.CreateStoryErrorModel.self, from: data)
//                            print("AuthError = \(result.errors!.errorText)")
//                            completionBlock(nil,result,nil)
//
//                        }
//
//                    }else{
//                        print("error = \(response.error?.localizedDescription)")
//                        completionBlock(nil,nil,response.error)
//                    }
//
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                completionBlock(nil,nil,error)
//
//            }
//        }
    }
    func deleteStory(storyId:Int, completionBlock: @escaping (_ Success:DeleteStoryModel.DeleteStorySuccessModel?,_ SessionError:DeleteStoryModel.DeleteStoryErrorModel?, Error?) ->()){
        
       let params = [
                  APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                  APIClient.Params.story_id:storyId,
                  ] as [String : Any]
              let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.Stories.deleteStory + access_token, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Any else {return}
                if apiStatus as? Int == 200{
                    print("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try! JSONDecoder().decode(DeleteStoryModel.DeleteStorySuccessModel.self, from: data)
                    completionBlock(result,nil,nil)
                }else{
                    print("apiStatus String = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try! JSONDecoder().decode(DeleteStoryModel.DeleteStoryErrorModel.self, from: data)
                    print("AuthError = \(result.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                print("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    //messenger
    func getStories(session_Token: String,limit:Int, completionBlock: @escaping (_ Success:GetStoriesModel.GetStoriesSuccessModel?,_ AuthError:GetStoriesModel.GetStoriesErrorModel?,_ ServerKeyError:GetStoriesModel.ServerKeyErrorModel?, Error?) ->()){

        let params = [
            API.Params.List_id : limit,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]

        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        log.verbose("API = \(API.Stories_Constants_Methods.GET_STORIES_API)")
        AF.request(API.Stories_Constants_Methods.GET_STORIES_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(GetStoriesModel.GetStoriesSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.stories ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetStoriesModel.GetStoriesErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(GetStoriesModel.ServerKeyErrorModel.self, from: data!)
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
    func createStory(session_Token: String,type:String,storyDescription:String,storyTitle:String,data:Data?, completionBlock: @escaping (_ Success:CreateStoryModel.CreateStorySuccessModel?,_ AuthError:CreateStoryModel.CreateStoryErrorModel?,_ ServerKeyError:CreateStoryModel.ServerKeyErrorModel?, Error?) ->()){
        
        let params = [
            API.Params.FileType : type,
            API.Params.StoryDescription : storyDescription,
            API.Params.StoryTitle : storyTitle,
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
            if let data = data{
                multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/png")
            }
            
        }, to: API.Stories_Constants_Methods.CREATE_STORY_API + "\(session_Token)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            print("Succesfully uploaded")
            log.verbose("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(CreateStoryModel.CreateStorySuccessModel.self, from: data)
                    log.debug("Success = \(result.storyID ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CreateStoryModel.CreateStoryErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(CreateStoryModel.ServerKeyErrorModel.self, from: data)
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
    func deleteStory(session_Token: String,story_id:String, completionBlock: @escaping (_ Success:DeleteStoryModel.DeleteStorySuccessModel?,_ AuthError:DeleteStoryModel.DeleteStoryErrorModel?,_ ServerKeyError:DeleteStoryModel.ServerKeyErrorModel?, Error?) ->()){
        let converted = Int(story_id)
        let params = [
            API.Params.storyID : converted,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        AF.request(API.Stories_Constants_Methods.DELETE_STORY_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(DeleteStoryModel.DeleteStorySuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? "")")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteStoryModel.DeleteStoryErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteStoryModel.ServerKeyErrorModel.self, from: data)
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
    
    static let sharedInstance = StoriesManager()
    private init() {}
}
