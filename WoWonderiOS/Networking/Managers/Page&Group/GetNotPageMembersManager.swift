
import Foundation
import Alamofire
import WoWonderTimelineSDK


class GetNotPageMemberManager {
    
    func getNotPageMember(pageId : Int,completionBlock : @escaping (_ Success:GetNotPageMembersModel.GetNotPageMember_SuccessModel?, _ AuthError : GetNotPageMembersModel.GetNotPageMember_ErrorModel? , Error?)->()){
        
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key, APIClient.Params.pageId :pageId] as [String : Any]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.GetNotPageMemebers.getNotPageMemebrsApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
        guard let res = response.value as? [String:Any] else {return}
        guard let apiStatusCode = res["api_status"]  as? Any else {return}
        let apiCode = apiStatusCode as? Int
                if apiCode == 200 {
                    let result = GetNotPageMembersModel.GetNotPageMember_SuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetNotPageMembersModel.GetNotPageMember_ErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
                
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
        
        
    }
    
    
 static let sharedInstance = GetNotPageMemberManager()
 private init() {}
    
}
