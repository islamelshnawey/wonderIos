

import Foundation
import Alamofire
import WoWonderTimelineSDK

class GetGroupPostsManager{
    
    func getGroupPost(groupId : String,afterPostId : String, completionBlock : @escaping (_ Success:GetGroupPostModel.getGroupPost_SuccessModel?, _ AuthError : GetGroupPostModel.getGroupPost_ErrorModel? , Error?)->()){
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key,APIClient.Params.type : "get_group_posts", APIClient.Params.limit : 10, APIClient.Params.id : groupId, APIClient.Params.afterPostId : afterPostId] as [String : Any]
    let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.GetGroupPost.getGroupPostApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
            guard let res = response.value as? [String:Any] else {return}
            guard let apiStatusCode = res["api_status"]  as? Any else {return}
            let apiCode = apiStatusCode as? Int
            if apiCode == 200 {
            let result = GetGroupPostModel.getGroupPost_SuccessModel.init(json: res)
            completionBlock(result,nil,nil)
                }
            else {
        guard let data = try? JSONSerialization.data(withJSONObject:response.value, options: []) else {return}
        guard let result = try? JSONDecoder().decode(GetGroupPostModel.getGroupPost_ErrorModel.self, from: data) else {return}
        completionBlock(nil,result,nil)
                }
                
            }
            
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = GetGroupPostsManager()
    private init() {}
    
}
