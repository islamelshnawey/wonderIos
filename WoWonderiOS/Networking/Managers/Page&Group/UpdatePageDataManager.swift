
import Foundation
import Alamofire
import WoWonderTimelineSDK


class UpdatePageDataManager{
    
    let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"

    func updatePageData (params : [String:Any], completionBlock : @escaping (_ Success: UpdatePageDataModel.updatePageData_SuccessModel?, _ AuthError : UpdatePageDataModel.updatePageData_ErrorModel? , Error?)->()){
        AF.request(APIClient.UpdatePageData.updatePageDataApi + self.access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
            if response.value != nil {
        guard let res = response.value as? [String:Any] else {return}
        guard let apiStatusCode = res["api_status"] as? Any else {return}
          if apiStatusCode as? Int == 200{
            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
            guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_SuccessModel.self, from: data) else {return}
            completionBlock(result,nil,nil)
            
                }
          else {
            guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
            guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_ErrorModel.self, from: data) else {return}
            completionBlock(nil,result,nil)
              }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
  
    
    func uploadImage(pageId : String, imageType : String ,data : Data?, completionBlock : @escaping (_ Success: UpdatePageDataModel.updatePageData_SuccessModel?, _ AuthError : UpdatePageDataModel.updatePageData_ErrorModel? , Error?)->()){
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key,APIClient.Params.pageId : pageId]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = data{
            multipartFormData.append(data, withName: imageType, fileName: "file.jpg", mimeType: "image/png")
            }
        }, with: APIClient.UpdatePageData.updatePageDataApi + self.access_token as! URLRequestConvertible)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            //Do what ever you want to do with response
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
        guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_SuccessModel.self, from: data) else {return}
            completionBlock(result,nil,nil)
                }
                else {
        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
        guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_ErrorModel.self, from: data) else {return}
            completionBlock(nil,result,nil)
                        }
                    }
                    else{
                        print(response.error?.localizedDescription)
                        completionBlock(nil,nil,response.error)
                    }
        })
//        },usingThreshold: UInt64.init(),to: APIClient.UpdatePageData.updatePageDataApi + self.access_token,method : .post,headers: headers) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { (response) in
//                    if (response.value != nil){
//                guard let res = response.value as? [String:Any] else {return}
//                guard let apiStatusCode = res["api_status"] as? Any else {return}
//                if apiStatusCode as? Int == 200{
//        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
//        guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_SuccessModel.self, from: data) else {return}
//            completionBlock(result,nil,nil)
//                }
//                else {
//        guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
//        guard let result = try? JSONDecoder().decode(UpdatePageDataModel.updatePageData_ErrorModel.self, from: data) else {return}
//            completionBlock(nil,result,nil)
//                        }
//                    }
//                    else{
//                        print(response.error?.localizedDescription)
//                        completionBlock(nil,nil,response.error)
//                    }
//                }
//                case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                completionBlock(nil,nil,error)
//
//            }
//        }
    }
        
    
    static var sharedInstance = UpdatePageDataManager()
    private init() {}
    
    
}
