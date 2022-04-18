

import Foundation
import Alamofire
import WoWonderTimelineSDK

class AddPostManager{
    
    static let instance = AddPostManager()
    
    func addPostText(userID:String,postText:String, postColor:String,postPrivacy:Int,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String,completionBlock :@escaping (_ Success: AddPostModel.AddPostSuccessModel?, _ AuthError: AddPostModel.AddPostErrorModel?, Error?)->()){
        var param =  [String : Any]()
        if postType == "page"{
             param = [
            
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.userId:userID,
            APIClient.Params.s:UserData.getAccess_Token() ?? "",
            APIClient.Params.postText:postText,
            APIClient.Params.post_color:postColor,
            APIClient.Params.postPrivacy:postPrivacy,
                APIClient.Params.page_id:pageID ?? "","postMap":location
            ]
        }else if postType == "group"{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,
                        APIClient.Params.group_id:groupID ?? "","postMap":location
                      ]
            
        }else if postType == "event"{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,
                        APIClient.Params.event_id:eventID ?? "","postMap":location
                      ]
        }else{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,"postMap":location
                      ]
        }
        
        print("PARAMS= \(param)")
        print("URL",APIClient.AddPost.AddPostApi)
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.AddPost.AddPostApi, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? String == "200"{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    let result = AddPostModel.AddPostSuccessModel.init(json: res)
//                    try? JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
                    print("result",result)
                    completionBlock(result,nil,nil)
                }
                    
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    func addImages(userID:String,postText:String, postColor:String,postPrivacy:Int,imageDataArray:[Data]?,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String, completionBlock: @escaping (_ Success:AddPostModel.AddPostSuccessModel?,_ AuthError:AddPostModel.AddPostErrorModel?, Error?) ->()){
        
       var param =  [String : Any]()
        if postType == "page"{
             param = [
            
            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
            APIClient.Params.userId:userID,
            APIClient.Params.s:UserData.getAccess_Token() ?? "",
            APIClient.Params.postText:postText,
            APIClient.Params.post_color:postColor,
            APIClient.Params.postPrivacy:postPrivacy,
            APIClient.Params.page_id:pageID ?? "","postMap":location
            ]
        }else if postType == "group"{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,
                      APIClient.Params.group_id:groupID ?? "","postMap":location
                      ]
            
        }else if postType == "event"{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,
                      APIClient.Params.event_id:eventID ?? "","postMap":location
                      ]
        }else{
            param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,"postMap":location
                      
                      ]
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: param, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            print("============")
            print("1")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            print("============")
            print("2")
            if imageDataArray!.count >
                1{
                for data in imageDataArray!{
                    multipartFormData.append(data, withName: "postPhotos[]", fileName: "file.png", mimeType: "image/png")
                }
            }else{
                let data1 =  imageDataArray?[0]
                if let data = data1{
                    multipartFormData.append(data, withName: "postPhoto", fileName: "file.png", mimeType: "image/png")
                }
            }
            print("============")
            print("3")
            print("API =\(APIClient.AddPost.AddPostApi)")
          
            
        }, to: APIClient.AddPost.AddPostApi + "\("&")\("access_token")\("=")\(UserData.getAccess_Token()!)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON{ (result) in
            switch result.result{
            case .success(let response):
//                upload.responseJSON { response in
                    print("Succesfully uploaded")
                
                print("response = \(response)")
                if (response != nil){
                    
                        guard let res = response as? [String:Any] else {return}
                        print("Response = \(res)")
                        guard let apiStatusCode = res["api_status"] as? Any else {return}
                        if apiStatusCode as? String == "200"{
                            print("apiStatus Int = \(apiStatusCode)")
                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
                            let result = AddPostModel.AddPostSuccessModel.init(json: res)

//                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
//                            print("Success = \(result.apiText ?? "")")
                            completionBlock(result,nil,nil)
                        }else{
                            print("apiStatus String = \(apiStatusCode)")
                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
                            let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
                            print("AuthError = \(result.errors!.errorText)")
                            completionBlock(nil,result,nil)
                            
                        }
                        
                    }else{
//                        print("error = \(response.localizedDescription)")
//                        completionBlock(nil,nil,response?.description)
//                        completionBlock(nil, nil, response)
                    }
//                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(nil,nil,error)
                
            }
        }
    }
//
//    func sendChatData(message_hash_id: Int,receipent_id:String,session_Token: String,type:String, audio_data:Data? ,image_data:Data?,video_data:Data?,imageMimeType:String?,videoMimeType:String?, audioMimeType:String?,text:String,file_data:Data?,file_Extension:String?,fileMimeType:String?, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ AuthError:SendMessageModel.SendMessageErrorModel?,_ ServerKeyError:SendMessageModel.ServerKeyErrorModel?, Error?) ->()){
//
//            let covertedReceipientId = Int(receipent_id)
//            let params = [
//                API.Params.MessageHashId : message_hash_id,
//                API.Params.user_id : receipent_id,
//                API.Params.ServerKey : API.SERVER_KEY.Server_Key
//            ] as [String : Any]
//
//            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
//            let decoded = String(data: jsonData, encoding: .utf8)!
//            log.verbose("Decoded String = \(decoded)")
//            let headers: HTTPHeaders = [
//                "Content-type": "multipart/form-data"
//            ]
//
//            AF.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in params {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                }
//                if type == "image"{
//                    if let data = image_data{
//                        multipartFormData.append(data, withName:"file", fileName: "image.jpg", mimeType: imageMimeType ?? "")
//                    }
//
//                }
//                else if type == "video"{
//                    if let data = video_data{
//                        multipartFormData.append(data, withName: "file", fileName: "video.mp4", mimeType: videoMimeType ?? "")
//                    }
//                }
//
//                else if type == "audio"{
//                    if let data = audio_data {
//                        multipartFormData.append(data, withName: "file", fileName: "audio.\(file_Extension)", mimeType: audioMimeType ?? "")
//
//                    }
//                }
//
//                else{
//                    if let fileData = file_data{
//                        multipartFormData.append(fileData, withName: "file", fileName: "file.\(file_Extension ?? "")", mimeType: fileMimeType ?? "")
//                    }
//
//                }
//
//            }, to: API.Chat_Methods.SEND_MESSAGE_API + "\(session_Token)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON(completionHandler: { (response) in
//                print("Succesfully uploaded")
//                log.verbose("response = \(response.value)")
//                print("\(session_Token)")
//                if (response.value != nil){
//                    guard let res = response.value as? [String:Any] else {return}
//                    log.verbose("Response = \(res)")
//                    guard let apiStatus = res["api_status"]  as? Any else {return}
//                    if apiStatus is Int{
//                        log.verbose("apiStatus Int = \(apiStatus)")
//                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                        let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
//                        log.debug("Success = \(result.apiStatus ?? nil)")
//                        completionBlock(result,nil,nil,nil)
//                    }else{
//                        let apiStatusString = apiStatus as? String
//                        if apiStatusString == "400" {
//                            log.verbose("apiStatus String = \(apiStatus)")
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
//                            log.error("AuthError = \(result.errors!.errorText)")
//                            completionBlock(nil,result,nil,nil)
//                        }else if apiStatusString == "404" {
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
//                            log.error("AuthError = \(result.errors!.errorText)")
//                            completionBlock(nil,nil,result,nil)
//                        }
//                    }
//                }else{
//                    log.error("error = \(response.error?.localizedDescription)")
//                    completionBlock(nil,nil,nil,response.error)
//                }
//            })
//        }
    func addVideo(userID:String,postText:String, postColor:String,postPrivacy:Int,videoData:Data?,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String, completionBlock: @escaping (_ Success:AddPostModel.AddPostSuccessModel?,_ AuthError:AddPostModel.AddPostErrorModel?, Error?) ->()){
           
         var param =  [String : Any]()
                  if postType == "page"{
                       param = [
                      
                      APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                      APIClient.Params.userId:userID,
                      APIClient.Params.s:UserData.getAccess_Token() ?? "",
                      APIClient.Params.postText:postText,
                      APIClient.Params.post_color:postColor,
                      APIClient.Params.postPrivacy:postPrivacy,
                        APIClient.Params.page_id:pageID ?? "","postMap":location
                      ]
                  }else if postType == "group"{
                      param = [
                                
                                APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                APIClient.Params.userId:userID,
                                APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                APIClient.Params.postText:postText,
                                APIClient.Params.post_color:postColor,
                                APIClient.Params.postPrivacy:postPrivacy,
                                APIClient.Params.group_id:groupID ?? "","postMap":location
                                ]
                      
                  }else if postType == "event"{
                      param = [
                                
                                APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                APIClient.Params.userId:userID,
                                APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                APIClient.Params.postText:postText,
                                APIClient.Params.post_color:postColor,
                                APIClient.Params.postPrivacy:postPrivacy,
                                  APIClient.Params.event_id:eventID ?? "","postMap":location
                                ]
                  }else{
                      param = [
                                
                                APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                APIClient.Params.userId:userID,
                                APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                APIClient.Params.postText:postText,
                                APIClient.Params.post_color:postColor,
                                APIClient.Params.postPrivacy:postPrivacy,"postMap":location
                                ]
                  }
           
           let jsonData = try! JSONSerialization.data(withJSONObject: param, options: [])
           let decoded = String(data: jsonData, encoding: .utf8)!
           print("Decoded String = \(decoded)")
           let headers: HTTPHeaders = [
               "Content-type": "multipart/form-data"
           ]
           
           AF.upload(multipartFormData: { (multipartFormData) in
               for (key, value) in param {
                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
               }
              if let data = videoData{
                            multipartFormData.append(data, withName: "postVideo", fileName: "video.mp4", mimeType: "video/mp4")
                         }
                        
           }, to: APIClient.AddPost.AddPostApi, method: .post, headers: headers).responseJSON { (result) in
            
            //            case .success(let response):
            ////                upload.responseJSON { response in
            //                    print("Succesfully uploaded")
            ////                    print("response = \(response.result.value)")
            //                if (response != nil){
            //                        guard let res = response as? [String:Any] else {return}
            //                        print("Response = \(res)")
            //                        guard let apiStatusCode = res["api_status"] as? Any else {return}
            //                        if apiStatusCode as? String == "200"{
            //                            print("apiStatus Int = \(apiStatusCode)")
            //                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            //                            let result = AddPostModel.AddPostSuccessModel.init(json: res)
            //
            ////                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
            ////                            print("Success = \(result.apiText ?? "")")
            //                            completionBlock(result,nil,nil)
            //                        }else{
            //                            print("apiStatus String = \(apiStatusCode)")
            //                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
            //                            let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
            //                            print("AuthError = \(result.errors!.errorText)")
            //                            completionBlock(nil,result,nil)
            //
            //                        }
            //
            //                    }else{
            ////                        print("error = \(response.localizedDescription)")
            ////                        completionBlock(nil,nil,response?.description)
            ////                        completionBlock(nil, nil, response)
            //                    }
            ////                }
            //            case .failure(let error):
            //                print("Error in upload: \(error.localizedDescription)")
            //                completionBlock(nil,nil,error)
            //
            //            }
           
           
           
//           .response { (result) in
            switch result.result{
            case .success(let response):
//                upload.responseJSON { response in
                    print("Succesfully uploaded")
//                    print("response = \(response.result.value)")
                if (response != nil){
                        guard let res = response as? [String:Any] else {return}
                        print("Response = \(res)")
                        guard let apiStatusCode = res["api_status"] as? Any else {return}
                        if apiStatusCode as? String == "200"{
                            print("apiStatus Int = \(apiStatusCode)")
                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
                            let result = AddPostModel.AddPostSuccessModel.init(json: res)

//                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
//                            print("Success = \(result.apiText ?? "")")
                            completionBlock(result,nil,nil)
                        }else{
                            print("apiStatus String = \(apiStatusCode)")
                            let data = try! JSONSerialization.data(withJSONObject: response, options: [])
                            let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
                            print("AuthError = \(result.errors!.errorText)")
                            completionBlock(nil,result,nil)

                        }

                    }else{
//                        print("error = \(response.localizedDescription)")
//                        completionBlock(nil,nil,response?.description)
//                        completionBlock(nil, nil, response)
                    }
//                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(nil,nil,error)

            }
//        }
           }
        
    }
    func postGiF(userID:String,postText:String, postColor:String,postPrivacy:Int,GIFUrl:String,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String,completionBlock :@escaping (_ Success: AddPostModel.AddPostSuccessModel?, _ AuthError: AddPostModel.AddPostErrorModel?, Error?)->()){
        var param =  [String : Any]()
                         if postType == "page"{
                              param = [
                             
                             APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                             APIClient.Params.userId:userID,
                             APIClient.Params.s:UserData.getAccess_Token() ?? "",
                             APIClient.Params.postText:postText,
                             APIClient.Params.post_color:postColor,
                             APIClient.Params.postPrivacy:postPrivacy,
                               APIClient.Params.page_id:pageID ?? "",
                                APIClient.Params.postSticker:GIFUrl,"postMap":location

                             ]
                         }else if postType == "group"{
                             param = [
                                       
                                       APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                       APIClient.Params.userId:userID,
                                       APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                       APIClient.Params.postText:postText,
                                       APIClient.Params.post_color:postColor,
                                       APIClient.Params.postPrivacy:postPrivacy,
                                         APIClient.Params.group_id:groupID ?? "",
                                         APIClient.Params.postSticker:GIFUrl,"postMap":location

                                       ]
                             
                         }else if postType == "event"{
                             param = [
                                       
                                       APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                       APIClient.Params.userId:userID,
                                       APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                       APIClient.Params.postText:postText,
                                       APIClient.Params.post_color:postColor,
                                       APIClient.Params.postPrivacy:postPrivacy,
                                         APIClient.Params.event_id:eventID ?? "",
                                    APIClient.Params.postSticker:GIFUrl,"postMap":location

                                       ]
                         }else{
                             param = [
                                       
                                       APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                       APIClient.Params.userId:userID,
                                       APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                       APIClient.Params.postText:postText,
                                       APIClient.Params.post_color:postColor,
                                       APIClient.Params.postPrivacy:postPrivacy,
                                       APIClient.Params.postSticker:GIFUrl,"postMap":location

                                       
                                       ]
                         }
        
          
          print("PARAMS= \(param)")
          let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.AddPost.AddPostApi, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil{
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? String == "200"{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    let result = AddPostModel.AddPostSuccessModel.init(json: res)
//                    try? JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
                    print("result",result)
                    completionBlock(result,nil,nil)
                }
                    
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
      }
    func postMusic(userID:String,postText:String, postColor:String,postPrivacy:Int,musicData:Data?,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String,completionBlock: @escaping (_ Success:AddPostModel.AddPostSuccessModel?,_ AuthError:AddPostModel.AddPostErrorModel?, Error?) ->()){
              
               var param =  [String : Any]()
                              if postType == "page"{
                                   param = [
                                  
                                  APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                  APIClient.Params.userId:userID,
                                  APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                  APIClient.Params.postText:postText,
                                  APIClient.Params.post_color:postColor,
                                  APIClient.Params.postPrivacy:postPrivacy,
                                    APIClient.Params.page_id:pageID ?? "","postMap":location
                                  ]
                              }else if postType == "group"{
                                  param = [
                                            
                                            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                            APIClient.Params.userId:userID,
                                            APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                            APIClient.Params.postText:postText,
                                            APIClient.Params.post_color:postColor,
                                            APIClient.Params.postPrivacy:postPrivacy,
                                              APIClient.Params.group_id:groupID ?? "","postMap":location
                                            ]
                                  
                              }else if postType == "event"{
                                  param = [
                                            
                                            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                            APIClient.Params.userId:userID,
                                            APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                            APIClient.Params.postText:postText,
                                            APIClient.Params.post_color:postColor,
                                            APIClient.Params.postPrivacy:postPrivacy,
                                              APIClient.Params.event_id:eventID ?? "","postMap":location
                                            ]
                              }else{
                                  param = [
                                            
                                            APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                            APIClient.Params.userId:userID,
                                            APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                            APIClient.Params.postText:postText,
                                            APIClient.Params.post_color:postColor,
                                            APIClient.Params.postPrivacy:postPrivacy,"postMap":location
                                            
                                            
                                            ]
                              }
              
              let jsonData = try! JSONSerialization.data(withJSONObject: param, options: [])
              let decoded = String(data: jsonData, encoding: .utf8)!
              print("Decoded String = \(decoded)")
              let headers: HTTPHeaders = [
                  "Content-type": "multipart/form-data"
              ]
              
              AF.upload(multipartFormData: { (multipartFormData) in
                  for (key, value) in param {
                      multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                  }
                 if let data = musicData{
                               multipartFormData.append(data, withName: "postMusic", fileName: "music.mp3", mimeType: "audio/mp3")
                            }
                           
              }, with: APIClient.AddPost.AddPostApi as! URLRequestConvertible).uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            }).responseJSON(completionHandler: {
                response in
                print("Succesfully uploaded")
                print("response = \(response.value)")
                if (response.value != nil){
                    guard let res = response.value as? [String:Any] else {return}
                    print("Response = \(res)")
                    guard let apiStatusCode = res["api_status"] as? Any else {return}
                    if apiStatusCode as? String == "200"{
                        print("apiStatus Int = \(apiStatusCode)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = AddPostModel.AddPostSuccessModel.init(json: res)

    //                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
    //                            print("Success = \(result.apiText ?? "")")
                        completionBlock(result,nil,nil)
                    }else{
                        print("apiStatus String = \(apiStatusCode)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
                        print("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil)

                    }

                }else{
                    print("error = \(response.error?.localizedDescription)")
                    completionBlock(nil,nil,response.error)
                }
            })
          }
    func postFIle(userID:String,postText:String, postColor:String,postPrivacy:Int,fileData:Data?,extension1:String,pageID:String?,groupID:String?,eventID:String?,postType:String, completionBlock: @escaping (_ Success:AddPostModel.AddPostSuccessModel?,_ AuthError:AddPostModel.AddPostErrorModel?, Error?) ->()){
        
          var param =  [String : Any]()
                                    if postType == "page"{
                                         param = [
                                        
                                        APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                        APIClient.Params.userId:userID,
                                        APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                        APIClient.Params.postText:postText,
                                        APIClient.Params.post_color:postColor,
                                        APIClient.Params.postPrivacy:postPrivacy,
                                          APIClient.Params.page_id:pageID ?? "",
                                        ]
                                    }else if postType == "group"{
                                        param = [
                                                  
                                                  APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                  APIClient.Params.userId:userID,
                                                  APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                  APIClient.Params.postText:postText,
                                                  APIClient.Params.post_color:postColor,
                                                  APIClient.Params.postPrivacy:postPrivacy,
                                                    APIClient.Params.group_id:groupID ?? "",
                                                  ]
                                        
                                    }else if postType == "event"{
                                        param = [
                                                  
                                                  APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                  APIClient.Params.userId:userID,
                                                  APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                  APIClient.Params.postText:postText,
                                                  APIClient.Params.post_color:postColor,
                                                  APIClient.Params.postPrivacy:postPrivacy,
                                                    APIClient.Params.event_id:eventID ?? "",
                                                  ]
                                    }else{
                                        param = [
                                                  
                                                  APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                  APIClient.Params.userId:userID,
                                                  APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                  APIClient.Params.postText:postText,
                                                  APIClient.Params.post_color:postColor,
                                                  APIClient.Params.postPrivacy:postPrivacy,
                                                  
                                                  
                                                  ]
                                    }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: param, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
           if let data = fileData{
                         multipartFormData.append(data, withName: "postFile", fileName: "file.\(extension1)", mimeType: "file/\(extension1)")
                      }
                     
        }, with: APIClient.AddPost.AddPostApi as! URLRequestConvertible).uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: {
            response in
            print("Succesfully uploaded")
            print("response = \(response.value)")
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                print("Response = \(res)")
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? String == "200"{
                    print("apiStatus Int = \(apiStatusCode)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = AddPostModel.AddPostSuccessModel.init(json: res)

//                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
//                            print("Success = \(result.apiText ?? "")")
                    completionBlock(result,nil,nil)
                }else{
                    print("apiStatus String = \(apiStatusCode)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
                    print("AuthError = \(result.errors!.errorText)")
                    completionBlock(nil,result,nil)

                }

            }else{
                print("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,response.error)
            }
        })
//        to: APIClient.AddPost.AddPostApi, usingThreshold: UInt64.init(), method: .post, headers: headers) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print("Succesfully uploaded")
//                    print("response = \(response.value)")
//                    if (response.value != nil){
//                        guard let res = response.value as? [String:Any] else {return}
//                        print("Response = \(res)")
//                        guard let apiStatusCode = res["api_status"] as? Any else {return}
//                        if apiStatusCode as? String == "200"{
//                            print("apiStatus Int = \(apiStatusCode)")
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = AddPostModel.AddPostSuccessModel.init(json: res)
//
////                            let result = try! JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data)
////                            print("Success = \(result.apiText ?? "")")
//                            completionBlock(result,nil,nil)
//                        }else{
//                            print("apiStatus String = \(apiStatusCode)")
//                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
//                            let result = try! JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data)
//                            print("AuthError = \(result.errors!.errorText)")
//                            completionBlock(nil,result,nil)
//
//                        }
//
//                    }else{
//                        print("error = \(response.error?.localizedDescription)")
//                        completionBlock(nil,nil,response.error)
//                    }
//                }
//            case .failure(let error, _, _):
//                print("Error in upload: \(error.localizedDescription)")
//                completionBlock(nil,nil,error)
//
//            }
    }
    func addFeeling(userID:String,postText:String, postColor:String,postPrivacy:Int,feelingName:String,feelingType:String,pageID:String?,groupID:String?,eventID:String?,postType:String,location:String,completionBlock :@escaping (_ Success: AddPostModel.AddPostSuccessModel?, _ AuthError: AddPostModel.AddPostErrorModel?, Error?)->()){
        var param =  [String : Any]()
                                          if postType == "page"{
                                               param = [
                                              
                                              APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                              APIClient.Params.userId:userID,
                                              APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                              APIClient.Params.postText:postText,
                                              APIClient.Params.post_color:postColor,
                                              APIClient.Params.postPrivacy:postPrivacy,
                                                APIClient.Params.page_id:pageID ?? "",
                                                APIClient.Params.feeling:feelingName,
                                                APIClient.Params.feeling_type:feelingType,"postMap":location
                                              ]
                                          }else if postType == "group"{
                                              param = [
                                                        
                                                        APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                        APIClient.Params.userId:userID,
                                                        APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                        APIClient.Params.postText:postText,
                                                        APIClient.Params.post_color:postColor,
                                                        APIClient.Params.postPrivacy:postPrivacy,
                                                          APIClient.Params.group_id:groupID ?? "",
                                                          APIClient.Params.feeling:feelingName,
                                                          APIClient.Params.feeling_type:feelingType,"postMap":location
                                                        ]
                                              
                                          }else if postType == "event"{
                                              param = [
                                                        
                                                        APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                        APIClient.Params.userId:userID,
                                                        APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                        APIClient.Params.postText:postText,
                                                        APIClient.Params.post_color:postColor,
                                                        APIClient.Params.postPrivacy:postPrivacy,
                                                          APIClient.Params.event_id:eventID ?? "",
                                                          APIClient.Params.feeling:feelingName,
                                                          APIClient.Params.feeling_type:feelingType,"postMap":location
                                                        ]
                                          }else{
                                              param = [
                                                        
                                                        APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
                                                        APIClient.Params.userId:userID,
                                                        APIClient.Params.s:UserData.getAccess_Token() ?? "",
                                                        APIClient.Params.postText:postText,
                                                        APIClient.Params.post_color:postColor,
                                                        APIClient.Params.postPrivacy:postPrivacy,
                                                        APIClient.Params.feeling:feelingName,
                                                        APIClient.Params.feeling_type:feelingType,"postMap":location
                                                        ]
                                          }
          
          
          print("PARAMS= \(param)")
          let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
          AF.request(APIClient.AddPost.AddPostApi, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
              if response.value != nil{
                  guard let res = response.value as? [String:Any] else {return}
                  guard let apiStatusCode = res["api_status"] as? Any else {return}
                  if apiStatusCode as? String == "200"{
                      guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    let result = AddPostModel.AddPostSuccessModel.init(json: res)

//                      guard let result = try? JSONDecoder().decode(AddPostModel.AddPostSuccessModel.self, from: data) else {return}
                      completionBlock(result,nil,nil)
                  }
                      
                  else {
                      guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                      guard let result = try? JSONDecoder().decode(AddPostModel.AddPostErrorModel.self, from: data) else {return}
                      completionBlock(nil,result,nil)
                  }
              }
              else {
                  print(response.error?.localizedDescription)
                  completionBlock(nil,nil,response.error)
              }
          }
      }
      
    
    
}
