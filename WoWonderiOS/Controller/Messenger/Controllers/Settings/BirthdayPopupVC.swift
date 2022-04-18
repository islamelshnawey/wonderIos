

import UIKit
import Async
import WoWonderTimelineSDK

class BirthdayPopupVC: BaseVC {

    @IBOutlet weak var nobodyLabel: UILabel!
    @IBOutlet weak var peopleIFollowLabel: UILabel!
    @IBOutlet weak var everyoneLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var noBodyBtn: UIButton!
    @IBOutlet weak var peopleIFollowBtn: UIButton!
    @IBOutlet weak var everyOneBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    private var tag : Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    

  
    @IBAction func everyonePressed(_ sender: Any) {
        everyOneBtn.setImage(R.image.ic_radio_on(), for: .normal)
        peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
        noBodyBtn.setImage(R.image.ic_radio_off(), for: .normal)
        self.tag = 0 ?? 0
        updateData(withTag:self.tag)
    }
    
    
    @IBAction func peopleIFollowPressed(_ sender: Any) {
        everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
        peopleIFollowBtn.setImage(R.image.ic_radio_on(), for: .normal)
         noBodyBtn.setImage(R.image.ic_radio_off(), for: .normal)
         self.tag = 1 ?? 0
        updateData(withTag:self.tag)
    }
    
    @IBAction func nobodyPressed(_ sender: Any) {
        everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
        peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
        noBodyBtn.setImage(R.image.ic_radio_on(), for: .normal)
       self.tag = 2 ?? 0
        updateData(withTag:self.tag)
    }
    private func setupUI(){
        self.birthdayLabel.text = NSLocalizedString("Who can see my birthday?", comment: "")
        self.everyoneLabel.text = NSLocalizedString("Everyone", comment: "")
        self.peopleIFollowLabel.text = NSLocalizedString("People i Follow", comment: "")
        self.nobodyLabel.text = NSLocalizedString("No body", comment: "")
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: ""), for: .normal)
        if AppInstance.instance.userProfile?.birthPrivacy == "0"{
            everyOneBtn.setImage(R.image.ic_radio_on(), for: .normal)
            peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
            noBodyBtn.setImage(R.image.ic_radio_off(), for: .normal)
            
        }else if AppInstance.instance.userProfile?.birthPrivacy == "1"{
            everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
            peopleIFollowBtn.setImage(R.image.ic_radio_on(), for: .normal)
            noBodyBtn.setImage(R.image.ic_radio_off(), for: .normal)
            
        }else{
            everyOneBtn.setImage(R.image.ic_radio_off(), for: .normal)
            peopleIFollowBtn.setImage(R.image.ic_radio_off(), for: .normal)
            noBodyBtn.setImage(R.image.ic_radio_on(), for: .normal)
        }
    }
    private func updateData(withTag:Int?){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let tagCount  = withTag ?? 0
            Async.background({
                PrivacyManager.instance.updateBirthPrivacy(session_Token: sessionToken, tag: tagCount, completionBlock: { (success, sessionError, serverError, error) in
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
