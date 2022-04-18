

import UIKit
import Async
import WoWonderTimelineSDK
class AboutMeVC: BaseVC {
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var aboutMeTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func okPressed(_ sender: Any) {
        self.updateAboutMe()
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func setupUI(){
        self.okBtn.setTitleColor(.ButtonColor, for: .normal)
         self.cancelBtn.setTitleColor(.ButtonColor, for: .normal)
        self.aboutMeTextField.lineColor = .mainColor
        self.aboutMeLabel.text = NSLocalizedString("About me", comment: "")
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: .normal)
        self.okBtn.setTitle(NSLocalizedString("OK", comment: "OK"), for: .normal)
        self.aboutMeTextField.text = AppInstance.instance.userProfile?.about ?? ""
    }
    private func updateAboutMe(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let aboutMe  = self.aboutMeTextField.text ?? ""
        
        Async.background({
            SettingsManager.instance.updateAboutMe(session_Token: sessionToken, aboutme: aboutMe, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                          AppInstance.instance.fetchUserProfile(pass: nil)
                            self.dismiss(animated: true, completion: nil)
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
