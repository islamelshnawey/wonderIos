

import Foundation
import Alamofire
import WoWonderTimelineSDK

class VideosManager{

static let instance = VideosManager()

    func getUserVideos(Type:String,completionBlock :@escaping (_ Success: VideosModel.VideosSuccessModel?, _ AuthError: VideosModel.VideosErrorModel?, Error?)->()){
    let params = [
        APIClient.Params.serverKey:APIClient.SERVER_KEY.Server_Key,
        APIClient.Params.userId:UserData.getUSER_ID() ?? "",
        APIClient.Params.type:Type,
        
        ] as [String : Any]
    let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.VIDEOS.getUserVideos + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        if response.value != nil{
            guard let res = response.value as? [String:Any] else {return}
            guard let apiStatusCode = res["api_status"] as? Any else {return}
            if apiStatusCode as? Int == 200{
                guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                guard let result = try? JSONDecoder().decode(VideosModel.VideosSuccessModel.self, from: data) else {return}
                completionBlock(result,nil,nil)
            }
                
            else {
                guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                guard let result = try? JSONDecoder().decode(VideosModel.VideosErrorModel.self, from: data) else {return}
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
