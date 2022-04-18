

import UIKit
import Async
import WoWonderTimelineSDK
class SettingsSelectionPopupVC: BaseVC {
    
    @IBOutlet weak var peopleIFollowLabel: UILabel!
    @IBOutlet weak var everyoneLabel: UILabel!
    @IBOutlet weak var whoCanFollowMeLabel: UILabel!
    @IBOutlet weak var peopleIFollowBtn: UIButton!
    @IBOutlet weak var everyOneBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    private var tag : Int?  = 0
    var status:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func everyonePressed(_ sender: Any) {
        everyOneBtn.setImage(R.image.ic_radio_on(), for: .normal)
        peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
        self.tag = 0
        updateDataOnStatus(statusCheck: status!)
        
    }
    @IBAction func peopleFollowPressed(_ sender: Any) {
        everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
        peopleIFollowBtn.setImage(R.image.ic_radio_on(), for: .normal)
        self.tag = 1
        updateDataOnStatus(statusCheck: status!)

    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        self.whoCanFollowMeLabel.text = NSLocalizedString("Who can follow me?", comment: "")
        self.everyoneLabel.text = NSLocalizedString("Everyone", comment: "")
        self.peopleIFollowLabel.text = NSLocalizedString("People i Follow", comment: "")
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: ""), for: .normal)
        if status!{
            if AppInstance.instance.userProfile?.followPrivacy == "0"{
                everyOneBtn.setImage(R.image.ic_radio_on(), for: .normal)
                peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
                
            }else{
                everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
                peopleIFollowBtn.setImage(R.image.ic_radio_on(), for: .normal)
            }
        }else{
            if AppInstance.instance.userProfile?.messagePrivacy == "0"{
                everyOneBtn.setImage(R.image.ic_radio_on(), for: .normal)
                peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
            }else{
                everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
                peopleIFollowBtn.setImage(R.image.ic_radio_on(), for: .normal)
                
            }
        }
        
    }
    
    
    private func updateDataOnStatus(statusCheck:Bool){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let tagCount  = self.tag ?? 0
        if statusCheck{
            Async.background({
                PrivacyManager.instance.updateFollowPrivacy(session_Token: sessionToken, tag: tagCount, completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        print("Success")
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
            
        }else{
            Async.background({
                PrivacyManager.instance.updateMessagePrivacy(session_Token: sessionToken, tag: tagCount, completionBlock: { (success, sessionError, serverError, error) in
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
    
}
