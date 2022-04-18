
import UIKit
import Async
import SwiftEventBus
import WoWonderTimelineSDK

class SplashScreenVC: BaseVC {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            log.verbose("Internet connected!")
            self.showStack.isHidden = false
            self.activityIndicator.startAnimating()
           
      //      self.fetchUserProfile()
            self.getSetting()
        }
        
        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
            self.showStack.isHidden = true
            self.activityIndicator.stopAnimating()
            
            
        }
     //   self.fetchUserProfile()
        self.getSetting()
        
    }
    deinit {
        SwiftEventBus.unregister(self)
        
    }

    private func getSetting(){
        Async.background({
            GetSettingManager.sharedInstance.getSetting { (success, authError, error) in
                if (success != nil){
                    AppInstance.instance.userSetting = success?.config
             if let checkConnectivity = success?.config["connectivitySystem"] as? String{
                print(checkConnectivity)
                AppInstance.instance.connectivity_setting = checkConnectivity
                print("check",AppInstance.instance.connectivity_setting)
                    }

                }
                else if (authError != nil){
                    Async.main({
                        log.error("sessionError = \(authError?.errors.errorText)")
                    })
                }
                else if (error != nil){
                    Async.main({
                        log.error("error = \(error?.localizedDescription)")
                    })
                }
            }
        })
    }
    
    
//    private func fetchUserProfile(){
//        if appDelegate.isInternetConnected{
//            self.activityIndicator.startAnimating()
//            let status = AppInstance.instance.getUserSession()
//            if status{
//
//                let userId = AppInstance.instance.userId
//                let sessionId = AppInstance.instance.sessionId
//                Async.background({
//                    GetUserDataManager.instance.getUserData(user_id: userId ?? "" , session_Token: sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
//                        if success != nil{
//                            Async.main({
//                                log.debug("success = \(success?.userData)")
//                                AppInstance.instance.userProfile = success?.userData ?? nil
//                                SwiftEventBus.unregister(self)
//                                self.showStack.isHidden = true
////                                if SocketIOManager.sharedInstance.status  ?? false {
////                                    SocketIOManager.sharedInstance.sendJoin(message: "join", withNickname: ["username":success?.userData?.username ?? "","user_id" : AppInstance.instance.sessionId ?? ""])
////                                }
//
//
//
//                                self.activityIndicator.stopAnimating()
//                                let dashboardNav =  R.storyboard.dashboard.dashboard()
//                                dashboardNav?.modalPresentationStyle = .fullScreen
//                                self.present(dashboardNav!, animated: true, completion: nil)
//                            })
//                        }else if sessionError != nil{
//                            Async.main({
//                                self.activityIndicator.stopAnimating()
//                                self.showStack.isHidden = true
//                                log.error("sessionError = \(sessionError?.errors?.errorText)")
//                                self.view.makeToast(sessionError?.errors?.errorText)
//                            })
//
//                        }else if serverError != nil{
//                            Async.main({
//                                self.activityIndicator.stopAnimating()
//                                self.showStack.isHidden = true
//                                log.error("serverError = \(serverError?.errors?.errorText)")
//                                self.view.makeToast(serverError?.errors?.errorText)
//
//                            })
//                        }else {
//                            Async.main({
//                                self.activityIndicator.stopAnimating()
//                                self.showStack.isHidden = true
//                                log.error("error = \(error?.localizedDescription)")
//                                self.view.makeToast(error?.localizedDescription)
//
//                            })
//                        }
//                    }
//                })
//            }else{
//                SwiftEventBus.unregister(self)
//                let mainNav =  R.storyboard.main.main()
//                self.appDelegate.window?.rootViewController = mainNav
//            }
//        }else {
//            self.view.makeToast(InterNetError)
//
//        }
//
//    }
    
}
