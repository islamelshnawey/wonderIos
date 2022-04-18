//
//  LoginTableItem.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/24/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD
import GoogleSignIn
class LoginTableItem: UITableViewCell {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var facebookBtn: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var dontHaveLabel: UILabel!
    @IBOutlet weak var stayLoginLabel: UILabel!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    var  iconClick:Bool? = false
    var vc :LoginVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurImage.applyBlurEffect()
        loginBtn.addBlurEffect()
        facebookBtn.applyBlurEffect1()
        googleBtn.applyBlurEffect1()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.emailTextField.placeholder = NSLocalizedString("Enter your Email", comment: "Enter your Email")
        self.passwordTextField.placeholder = NSLocalizedString("Enter your Password", comment: "Enter your Password")
        self.loginBtn.setTitle(NSLocalizedString("Sign in", comment: "Sign in"), for: .normal)
        self.forgetPasswordBtn.setTitle(NSLocalizedString("Forget Password?", comment: "Forget Password?"), for: .normal)
        self.stayLoginLabel.text = NSLocalizedString("Stay login to your account to be", comment: "Stay login to your account to be")
        self.dontHaveLabel.text = NSLocalizedString("Stay login to your account to be", comment: "Stay login to your account to be")
        let googleBtnClip = UITapGestureRecognizer(target: self, action:  #selector(self.googleBtnPressed))
        self.googleBtn.addGestureRecognizer(googleBtnClip)
        
        let facebookClip = UITapGestureRecognizer(target: self, action:  #selector(self.facebookBtnPressed))
        self.facebookBtn.addGestureRecognizer(facebookClip)
    }
    
    @objc func googleBtnPressed(sender : UITapGestureRecognizer) {
        GIDSignIn.sharedInstance()?.presentingViewController = self.vc
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func facebookBtnPressed(sender : UITapGestureRecognizer) {
        self.vc?.facebookLogin()
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        let vc = R.storyboard.authentication.registerStartVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func showHidePressed(_ sender: Any) {
        iconClick = !iconClick!
        if(iconClick == true) {
            self.eyeBtn.setImage(UIImage(named: "show"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            self.eyeBtn.setImage(UIImage(named: "hidePass"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if self.emailTextField.text?.isEmpty == true {
            self.vc?.error = NSLocalizedString("Error, Required Username", comment: "Error, Required Username")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.vc?.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalPresentationStyle = .overFullScreen
            self.vc?.present(vc!, animated: true, completion: nil)
        }
        else if self.passwordTextField.text?.isEmpty == true {
            self.vc?.error = NSLocalizedString("Error, Required Password", comment: "Error, Required Password")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.vc?.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            self.vc?.present(vc!, animated: true, completion: nil)
        }
        else {
            ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
            self.vc?.loginAuthentication(userName: self.emailTextField.text!, password: self.passwordTextField.text!, deviceID: "")
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any){
        let vc = R.storyboard.authentication.forgotPasswordVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

@available(iOS 13.0, *)
extension LoginTableItem : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let userId = user.userID
            let idToken = user.authentication.accessToken
            print("user auth " ,idToken)
            let token = user.authentication.idToken ?? ""
            self.vc?.socialLogin(accesstoken: token, provider: "google", googleKey: ControlSettings.googleApiKey)
        }
        else {
            ZKProgressHUD.dismiss()
            print(error.localizedDescription)
        }
        
    }
}
