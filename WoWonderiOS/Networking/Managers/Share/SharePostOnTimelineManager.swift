

import Foundation
import Alamofire
import WoWonderTimelineSDK

class SharePostOnTimelineManager{
    
    func sharePostOnTimeline(userId :String, postId :String, completionBlock :@escaping (_ Success: SharePostOnTimlineModal.SharePostOnTimeline_SuccessModal?, _ AuthError: SharePostOnTimlineModal.SharePostOnTimeline_ErrorModal?, Error?)->()){
        
        let params = [APIClient.Params.serverKey :APIClient.SERVER_KEY.Server_Key,APIClient.Params.type :"share_post_on_timeline",APIClient.Params.userId :userId, APIClient.Params.id :postId]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.Share.sharePosts + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                    let result = SharePostOnTimlineModal.SharePostOnTimeline_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(SharePostOnTimlineModal.SharePostOnTimeline_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }

    }
    
    static let sharedInstance = SharePostOnTimelineManager()
    private init() {}
}
