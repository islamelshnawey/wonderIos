import WoWonderTimelineSDK
import Foundation
import CoreLocation
import Async
class AppInstance{
    
    //MARK: - timeline
    static let instance  = AppInstance()
    var profile:FetchUserModel.FetchUserSuccessModel?
//    var siteSettings:Get_Site_SettingModel.Site_Setting_SuccessModel?
    var siteSettings = [String:Any]()
    var isBackGroundSelected:Bool = false
    var  musicSelected:Bool = false
    var isAlbumVisible:Bool = false
    var locationManager: CLLocationManager!
    var addCount:Int? = 0
    var longitude:Double? = 0.0
    var latitude:Double? = 0.0
    var is_SharePost: String? = nil
    var index: Int? = nil
    var connectivity_setting = "1"
    var appColor =  "#984243"
    var showPayment = true
//        "#03fc0b"
//    #984243
    
    var commingBackFromAddPost = false
    var vc: String? = nil
    
    var newsFeed_data = [[String:Any]]()
    var suggested_users = [[String:Any]]()
    var suggested_groups = [[String:Any]]()
    var myGroups = [[String:Any]]()
    var myPages = [[String:Any]]()
    
     func getProfile(){
               DispatchQueue.main.async {
                   FetchUserManager.instance.fetchProfile { (success, authError, error) in
                       if success != nil {
                        AppInstance.instance.profile = success
                        UserData.setUSER_NAME(AppInstance.instance.profile?.userData?.name)
                        UserData.setWallet(AppInstance.instance.profile?.userData?.wallet)
                        UserData.SetImage(AppInstance.instance.profile?.userData?.avatar)
                        UserData.SetisPro(AppInstance.instance.profile?.userData?.isPro)
                           }
                       else if authError != nil {
                       }
                       else if error != nil {
                           print(error?.localizedDescription)
                       }
                   }
               }
       }
    
    
    
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
//            "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
//                "dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    //MARK: - Messenger
    var userId:String? = nil
    var sessionId:String? = nil
    var genderText:String? = "all"
    var profilePicText:String? = "all"
    var statusText:String? = "all"
   

    
    // MARK: -
    var userProfile:GetUserDataModel.UserData?
    var userSetting: [String:Any]?
    
    func getUserSession()->Bool{
        log.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
        let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
        if localUserSessionData.isEmpty{
            return false
            
        }else {
            self.userId = localUserSessionData[Local.USER_SESSION.User_id] as! String
            self.sessionId = localUserSessionData[Local.USER_SESSION.Access_token] as! String
            
            return true
        }
        
    }
    
    
    func fetchUserProfile(pass:String?){
            let status = AppInstance.instance.getUserSession()
            if status{
                let userId = AppInstance.instance.userId
                let sessionId = AppInstance.instance.sessionId
                Async.background({
                    GetUserDataManager.instance.getUserData(user_id: userId ?? "" , session_Token: sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                log.debug("success = \(success?.userData)")
                                AppInstance.instance.userProfile = success?.userData ?? nil
                                UserDefaults.standard.setCOntinueAs(value: ["username":success?.userData?.username ?? "" ,"password":pass ?? ""], ForKey: "ContinueAs")
                                
                                
                            })
                        }else if sessionError != nil{
                            Async.main({
                               
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                              
                            })
                            
                        }else if serverError != nil{
                            Async.main({
                            
                                log.error("serverError = \(serverError?.errors?.errorText)")
                            
                                
                            })
                            
                        }else {
                            Async.main({
                                log.error("error = \(error?.localizedDescription)")
                            })
                        }
                    }
                })
        }else {
            log.error(InterNetError)
        }
        
    }
}
