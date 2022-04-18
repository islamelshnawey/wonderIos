//
//  LoginVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/24/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD
import FBSDKLoginKit
import GoogleSignIn
import WoWonderTimelineSDK
import AuthenticationServices


class LoginVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var error = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loginImage")
        backgroundImage.contentMode = .redraw
        self.view.insertSubview(backgroundImage, at: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "LoginTableItem", bundle: nil), forCellReuseIdentifier: "LoginTableItem")
//        self.tableView.backgroundColor = .black
    }
    
    func loginAuthentication (userName:String, password : String,deviceID:String) {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.error = NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
            
        case .online(.wwan), .online(.wiFi):
            
            AuthenticationManager.sharedInstance.loginAuthentication(userName: userName, password: password,deviceId:deviceID) { (success, authError, error) in
                
                if success != nil {
                    ZKProgressHUD.dismiss()
                    print("Login Succesfull =\(success?.message)")
                    if success?.message == NSLocalizedString("Please enter your confirmation code", comment: "Please enter your confirmation code"){
                        let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "twoFactorVC") as? twoFactorVC
                        vc?.userID = success?.userID ?? ""
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                        UserData.setaccess_token(success?.accessToken)
                        UserData.setUSER_ID(success?.userID)
                        AppInstance.instance.getProfile()
                        let vc = R.storyboard.authentication.introController()
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
                }
                else if authError != nil {
                    ZKProgressHUD.dismiss()
                    self.error = authError?.errors.errorText ?? ""
                    let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
                    vc?.error = self.error ?? ""
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                    print(authError?.errors.errorText)
                    
                }
                
                else if error != nil{
                    ZKProgressHUD.dismiss()
                    print("error - \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func facebookLogin () {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.error = NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
            
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
                        
                    }else{
                        let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
                        vc?.error = error?.localizedDescription ?? ""
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc!, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    func socialLogin(accesstoken : String, provider:String, googleKey : String){
        
        SocialLoginManager.sharedInstance.socailLogin(access_token: accesstoken, provider: provider, google_key: googleKey) { (success, authError, error) in
            if success != nil {
                ZKProgressHUD.dismiss()
                print("Login Succesfull")
                UserData.setaccess_token(success?.accessToken)
                AppInstance.instance.sessionId = success?.accessToken
                UserData.setUSER_ID(success?.userID)
                AppInstance.instance.getProfile()
                let vc = R.storyboard.authentication.introController()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else if authError != nil {
                ZKProgressHUD.dismiss()
                self.error = authError?.errors?.errorText ?? ""
                let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
                vc?.error = self.error ?? ""
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
                print(authError?.errors?.errorText)
            }
            else if error != nil {
                ZKProgressHUD.dismiss()
                print("error")
            }
        }
    }
}
extension LoginVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTableItem" ) as? LoginTableItem
        cell!.vc = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900.0
    }
    
}

@available(iOS 13.0, *)
extension LoginVC:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.authorizationCode
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let authorizationCode = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
            print("authorizationCode: \(authorizationCode)")
            self.socialLogin(accesstoken: authorizationCode, provider: "apple", googleKey: "")
            
            
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
}
