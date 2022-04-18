

import Foundation
import Alamofire
import WoWonderTimelineSDK


class GetSavedPostManager{
    
    func getSavedPost(afterPostId: String, completionBlock :@escaping (_ Success: GetSavedPostModal.getSavedPost_SuccessModal?, _ AuthError: GetSavedPostModal.getSavedPost_ErrorModal?, Error?)->()){
        let params = [APIClient.Params.serverKey: APIClient.SERVER_KEY.Server_Key, APIClient.Params.limit: 10, APIClient.Params.afterPostId:afterPostId,APIClient.Params.type:"saved"] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        AF.request(APIClient.GetSavedPost.getSavedPostApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
                    let result = GetSavedPostModal.getSavedPost_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetSavedPostModal.getSavedPost_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = GetSavedPostManager()
    private init() {}

}
