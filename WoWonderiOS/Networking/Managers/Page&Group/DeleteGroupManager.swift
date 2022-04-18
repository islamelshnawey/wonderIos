
import Foundation
import Alamofire
import WoWonderTimelineSDK


class DeleteGroupManager{
    
    func deleteGroup (group_id : String, password : String,completionBlock : @escaping (_ Success: DeleteGroupModel.DeleteGroup_SuccessModel?, _ AuthError : DeleteGroupModel.DeleteGroup_ErrorModel? , Error?)->()){
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key ,APIClient.Params.groupId : group_id, APIClient.Params.password : password]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.DeleteGroup.deleteGroupApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200{
                guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                guard let result = try? JSONDecoder().decode(DeleteGroupModel.DeleteGroup_SuccessModel.self, from: data) else {return}
                    completionBlock(result,nil,nil)
                }
                
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(DeleteGroupModel.DeleteGroup_ErrorModel.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    static let sharedInstance = DeleteGroupManager()
    private init() {}
    
}
