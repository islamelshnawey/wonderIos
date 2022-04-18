//
//  RegisterStartVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/25/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD
import GoogleSignIn
import FBSDKLoginKit

class RegisterStartVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var error = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterStartVC.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func setupUI(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loginImage")
        backgroundImage.contentMode = .redraw
        self.view.insertSubview(backgroundImage, at: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "RegisterStartTableItem", bundle: nil), forCellReuseIdentifier: "RegisterStartTableItem")
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    
    func googleLogin(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func facebookLogin () {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.error = NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed")
            self.showErrorPopup(error: self.error)
            
        case .online(.wwan), .online(.wiFi):
            //            ZKProgressHUD.show("Loading")
            let fbLoginManager : LoginManager = LoginManager()
            
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                if (error == nil) {
                    ZKProgressHUD.dismiss()
                    let fbloginresult : LoginManagerLoginResult = result!
                    if(fbloginresult.isCancelled) {
                        //Show Cancel alert
                        ZKProgressHUD.dismiss()
                        print("cancelResult",fbloginresult.isCancelled)
                    }
                    else if (fbloginresult.grantedPermissions != nil){
                        ZKProgressHUD.dismiss()
                        if fbloginresult.grantedPermissions.contains("email"){
                            if AccessToken.current != nil {
                                ZKProgressHUD.dismiss()
                                GraphRequest(graphPath: "me", parameters: ["fields":"email,name,id,picture.type(large),first_name,last_name"])
                                    .start(completionHandler: { (connection, result, error) -> Void in
                                        if error == nil{
                                            let dic = result as! [String:Any]
                                            print("Dic result",dic)
                                            
                                            guard let firstName = dic["first_name"] as? String else {return}
                                            guard let lastName = dic["last_name"] as? String else {return}
                                            guard let email = dic["email"] as? String else {return}
                                            let token = AccessToken.current!.tokenString
                                            print("Token",token)
                                            
                                            ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
                                            self.socialLogin(accesstoken: token ?? "", provider: "facebook", googleKey: "")
                                            
                                        }
                                        
                                    })
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    private func socialLogin(accesstoken : String, provider:String, googleKey : String){
        
        SocialLoginManager.sharedInstance.socailLogin(access_token: accesstoken, provider: provider, google_key: googleKey) { (success, authError, error) in
            if success != nil {
                ZKProgressHUD.dismiss()
                print("Login Succesfull")
                UserData.setaccess_token(success?.accessToken)
                UserData.setUSER_ID(success?.userID)
                AppInstance.instance.getProfile()
                let vc = R.storyboard.authentication.introController()
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if authError != nil {
                ZKProgressHUD.dismiss()
                self.error = authError?.errors?.errorText ?? ""
//                self.performSegue(withIdentifier: "ErrorVC", sender: self)
                self.showErrorPopup(error: (authError?.errors!.errorText)!)
                print(authError?.errors?.errorText)
            }
            else if error != nil {
                ZKProgressHUD.dismiss()
                print("error")
            }
        }
    }
    
    func showErrorPopup(error:String){
        let vc = R.storyboard.authentication.securityController()
        vc?.error = error
        self.present(vc!, animated: true, completion: nil)
    }
}
extension RegisterStartVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterStartTableItem" ) as? RegisterStartTableItem
        cell?.vc = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700.0
    }
    
}

@available(iOS 13.0, *)
extension RegisterStartVC : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let userId = user.userID
            let idToken = user.authentication.accessToken
            print("user auth " ,idToken)
            let token = user.authentication.idToken ?? ""
            socialLogin(accesstoken: token, provider: "google", googleKey: ControlSettings.googleApiKey)
        }
        else {
            ZKProgressHUD.dismiss()
            print(error.localizedDescription)
        }
        
    }
}
