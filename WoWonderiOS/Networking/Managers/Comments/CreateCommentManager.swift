

import Foundation
import Alamofire
import WoWonderTimelineSDK

class CreateCommentsManager {
    
    func createComment (audio_data: Data?,data :Data?,postId : String, text : String, completionBlock : @escaping (_ Success:CreateCommentModel.createComment_SuccessModel?, _ AuthError : CreateCommentModel.createComment_ErrorModel? , Error?)->()){
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key,APIClient.Params.type : "create", APIClient.Params.text : text,APIClient.Params.postId :postId]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = data{
                multipartFormData.append(data, withName: "image", fileName: "file.jpg", mimeType: "image/png")
            }
            if let voice_data = audio_data{
                multipartFormData.append(voice_data, withName: "audio", fileName: "audio.mp3", mimeType: "audio/mp3")
            }
        },with: APIClient.CreateCommentReply.createCommentReply as! URLRequestConvertible )
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { response in
                //Do what ever you want to do with response
                if response.value != nil {
                    guard let res = response.value as? [String:Any] else {return}
                    guard let apiStatusCode = res["api_status"]  as? Any else {return}
                    let apiCode = apiStatusCode as? Int
                    if apiCode == 200 {
                        let result = CreateCommentModel.createComment_SuccessModel.init(json: res)
                        completionBlock(result,nil,nil)
                    }
                    else {
                        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                        guard let result = try? JSONDecoder().decode(CreateCommentModel.createComment_ErrorModel.self, from: data)else {return}
                        completionBlock(nil,result,nil)
                    }
                }
                else {
                    print(response.error?.localizedDescription)
                    completionBlock(nil,nil,response.error)
                }
            })
//        },to: APIClient.CreateCommentReply.createCommentReply + access_token, usingThreshold: UInt64.init(),method: .post,headers: nil){
//            (result) in
//            print(result)
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { (response) in
//                    if response.value != nil {
//                        guard let res = response.value as? [String:Any] else {return}
//                        guard let apiStatusCode = res["api_status"]  as? Any else {return}
//                        let apiCode = apiStatusCode as? Int
//                        if apiCode == 200 {
//                            let result = CreateCommentModel.createComment_SuccessModel.init(json: res)
//                            completionBlock(result,nil,nil)
//                        }
//                        else {
//                            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
//                            guard let result = try? JSONDecoder().decode(CreateCommentModel.createComment_ErrorModel.self, from: data)else {return}
//                            completionBlock(nil,result,nil)
//                        }
//                    }
//                    else {
//                        print(response.error?.localizedDescription)
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
    
    static let sharedInstance = CreateCommentsManager()
    private init() {}
    
    
}
