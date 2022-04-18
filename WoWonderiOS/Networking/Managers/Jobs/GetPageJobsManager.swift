

import Foundation
import Alamofire
import WoWonderTimelineSDK

class GetPageJobsManager{
    
    func getJobs(pageId : String,offset : String,completionBlock : @escaping (_ Success: GetPageJobsModel.getPageJobs_SuccessModel?, _ AuthError : GetPageJobsModel.getPageJobs_ErrorModel? , Error?)->()){
        
        let params = [APIClient.Params.serverKey : APIClient.SERVER_KEY.Server_Key, APIClient.Params.type : "get", APIClient.Params.limit : 10, APIClient.Params.pageId : pageId, APIClient.Params.off_set : offset] as [String : Any]
         
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.Job.jobApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
                    let result =  GetPageJobsModel.getPageJobs_SuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    print(data)
                    guard let result = try? JSONDecoder().decode(GetPageJobsModel.getPageJobs_ErrorModel.self, from: data) else {return}
                    print(result)
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
        
    }
    
    static let sharedInstance = GetPageJobsManager()
    private init() {}
    
}
