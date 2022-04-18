
import UIKit
import Async
import WoWonderTimelineSDK

class ConfirmationCodeVC: BaseVC {
    
    @IBOutlet weak var codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendPressed(_ sender: Any) {
        if self.codeTextField.text!.isEmpty{
            self.view.makeToast(NSLocalizedString("Please enter code", comment: "Please enter code"))
        }else{
            self.verifyCode(code: self.codeTextField.text ?? "", Type: "verify")
        }
    }
    private func verifyCode(code:String,Type:String){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            TwoFactorManager1.instance.updateVerifyTwoFactor(session_Token: sessionToken, code: code, Type: Type) { (success, sessionError,serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            self.dismiss(animated: true) {
                                 AppInstance.instance.fetchUserProfile(pass: nil)
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors.errorText)
                            log.error("sessionError = \(sessionError?.errors.errorText)")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
                
            }
        })
    }
}
