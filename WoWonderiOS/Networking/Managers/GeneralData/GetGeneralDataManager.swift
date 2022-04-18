
import Foundation
import Alamofire
import WoWonderTimelineSDK

class GetGeneralDataManager {
    
    func getGeneralDataManager(fetch: String, offset: String, completionBlock :@escaping (_ Success: GetGeneralDataModal.getGeneralData_SuccessModal?, _ AuthError: GetGeneralDataModal.getGeneralData_ErrorModal?, Error?)->()) {
        
        let params = [APIClient.Params.serverKey: APIClient.SERVER_KEY.Server_Key, APIClient.Params.fetch: fetch, APIClient.Params.offset: offset]
        let access_token = "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)"
        
        AF.request(APIClient.GeneralData.getGeneralDataApi + access_token, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? Int == 200 {
                    let result = GetGeneralDataModal.getGeneralData_SuccessModal.init(json: res)
                    completionBlock(result,nil,nil)
                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(GetGeneralDataModal.getGeneralData_ErrorModal.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }        
    }
    
    func getLatestBlogs(completionBlock :@escaping (_ Success: TrendingModel.TrendingModel_Sucess?, _ AuthError: TrendingModel.TrendingModel_Error?, Error?)->()) {
        
        let params = [
            APIClient.Params.s: UserData.getAccess_Token() ?? "",
            APIClient.Params.userId : UserData.getUSER_ID() ?? ""]
        
        AF.request(APIClient.Get_Latest_Blog_POST.BlogPost, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatusCode = res["api_status"] as? Any else {return}
                if apiStatusCode as? String == "200" {
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    let result = try! JSONDecoder().decode(TrendingModel.TrendingModel_Sucess.self, from: data)
                    completionBlock(result,nil,nil)

                }
                else{
                    guard let data = try? JSONSerialization.data(withJSONObject: response.value, options: []) else {return}
                    guard let result = try? JSONDecoder().decode(TrendingModel.TrendingModel_Error.self, from: data) else {return}
                    completionBlock(nil,result,nil)
                }
            }
            else {
                print(response.error?.localizedDescription)
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
   static let sharedInstance = GetGeneralDataManager()
    private init() {}
}
