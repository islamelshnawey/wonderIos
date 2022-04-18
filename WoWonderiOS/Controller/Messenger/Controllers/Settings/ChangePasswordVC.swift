

import UIKit
import SkyFloatingLabelTextField
import Async
import WoWonderTimelineSDK

class ChangePasswordVC: BaseVC {

  
    @IBOutlet weak var repeatPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var currentPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var resetPasswordView: UIView!
    
    @IBOutlet weak var passLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        // Do any additional setup after loading the view.
    }
    
    private func updatePassword(){
        if (self.currentPasswordTextField.text?.isEmpty)!{
            self.view.makeToast(NSLocalizedString("Please enter current password.", comment: "Please enter current password."))
        }else if (self.newPasswordTextField.text?.isEmpty)!{
              self.view.makeToast(NSLocalizedString("Please enter current new password.", comment: "Please enter current new password."))
        }else if (self.repeatPasswordTextField.text?.isEmpty)!{
            self.view.makeToast(NSLocalizedString("Please enter current confirm password.", comment: "Please enter current confirm password."))
        }else if self.newPasswordTextField.text != self.repeatPasswordTextField.text{
             self.view.makeToast(NSLocalizedString("Password does not match. Try again!", comment: "Password does not match. Try again!"))
            
        }else {
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let sessionToken = AppInstance.instance.sessionId ?? ""
            let currentPassword = self.currentPasswordTextField.text ?? ""
            let newPassword = self.newPasswordTextField.text ?? ""
            
            Async.background({
                SettingsManager.instance.updatePassword(session_Token: sessionToken, currentPassword: currentPassword, newPassword: newPassword, completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(NSLocalizedString("Password has been changed!", comment: "Password has been changed!"))
                                 AppInstance.instance.fetchUserProfile(pass: nil)
                                
                            }
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                            
                        })
                        
                        
                    }else if serverError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                                self.view.makeToast(serverError?.errors?.errorText ?? "")
                            }
                            
                        })
                        
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                            
                        })
                        
                    }
                })
              
            })
        }
      
        
        
    }
   

    private func setupUI(){
        self.repeatPasswordTextField.text = nil

        self.repeatPasswordTextField.text = NSLocalizedString("If you forgot your password, you can reset it from here.", comment: "If you forgot your password, you can reset it from here.")
        self.currentPasswordTextField.placeholder = NSLocalizedString("Current Password", comment: "Current Password")
        self.newPasswordTextField.placeholder = NSLocalizedString("New Password", comment: "New Password")
        self.repeatPasswordTextField.placeholder = NSLocalizedString("Repeat Password", comment: "Repeat Password")
        self.currentPasswordTextField.selectedTitle = NSLocalizedString("Current Password", comment: "Current Password")
        self.newPasswordTextField.selectedTitle = NSLocalizedString("New Password", comment: "New Password")
        self.repeatPasswordTextField.selectedTitle = NSLocalizedString("Repeat Password", comment: "Repeat Password")
        
        self.title = NSLocalizedString("Change Password", comment: "Change Password")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let Save = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: Selector("Save"))
        self.navigationItem.rightBarButtonItem = Save
        
        let resetPasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(resetPasswordTapped(sender:)))
        self.resetPasswordView.addGestureRecognizer(resetPasswordTapGesture)
    }
    @objc func resetPasswordTapped(sender: UITapGestureRecognizer) {
        //let vc = R.storyboard.main.forgetPasswordVC()
      //  self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @objc func Save(){
log.verbose("savedPressed!!")
        self.updatePassword()
        
    }
    
    
    
}
