

import UIKit
import Async
import WoWonderTimelineSDK
class DeleteAccountVC: BaseVC {
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setupUI()
    }
    
    private func setupUI(){
        self.warningLabel.text = NSLocalizedString("Warning !", comment: "")
        self.downTextLabel.text = NSLocalizedString("Are you sure you want to delete the account from Chats", comment: "")
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: .normal)
        self.okBtn.setTitle(NSLocalizedString("OK", comment: "OK"), for: .normal)
    }
    @IBAction func okPressed(_ sender: Any) {
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let password = UserDefaults.standard.getPassword(Key: Local.USER_SESSION.Current_Password)
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            UserManager.instance.deleteUser(sessionToken: sessionToken, password: password, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main{
                        self.dismissProgressDialog{
                            log.verbose("Success = \(success?.message ?? "")")
                            UserDefaults.standard.clearUserDefaults()
//                            let vc = R.storyboard.main.main()
//                            self.appDelegate.window?.rootViewController = vc
//                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }else if sessionError != nil{
                    Async.main{
                        self.dismissProgressDialog {
                            log.verbose("session Error = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                        }
                    }
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            log.verbose("serverError = \(serverError?.errors?.errorText)")
                            self.view.makeToast(serverError?.errors?.errorText ?? "")
                            
                        }
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.verbose("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        }
                    })
                }

            })
           
        })
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
