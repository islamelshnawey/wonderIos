
import UIKit
import SkyFloatingLabelTextField
import Async
import WoWonderTimelineSDK
class MyAccountVC: BaseVC {
    
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var maleRadioBtn: UIButton!
    @IBOutlet weak var femaleRadioBtn: UIButton!
    @IBOutlet weak var emailTextField: RoundTextField!
    @IBOutlet weak var usernameTextField: RoundTextField!
    @IBOutlet weak var birthdayField: RoundTextField!
    
    private var gender:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.showData()
        self.maleRadioBtn.tintColor = .ButtonColor
          self.femaleRadioBtn.tintColor = .ButtonColor
        
    }
    
    @IBAction func genderPressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Select Gender", preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Male", style: .default) { action in
            self.gender = "male"
            self.genderBtn.setTitle("Male", for: .normal)
        }
        let female = UIAlertAction(title: "Female", style: .default) { action in
            self.gender = "female"
            self.genderBtn.setTitle("Female", for: .normal)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func maleRadioPressed(_ sender: Any) {
        maleRadioBtn.setImage(R.image.ic_radio_on(), for: .normal)
        femaleRadioBtn.setImage(R.image.ic_radio_off(), for: .normal)
        self.gender = "male"
    }
    
    @IBAction func femaleRadioPressed(_ sender: Any) {
        maleRadioBtn.setImage(R.image.ic_radio_off(), for: .normal)
        femaleRadioBtn.setImage(R.image.ic_radio_on(), for: .normal)
        self.gender = "female"
    }
    private func setupUI(){
        
        self.maleLabel.text = NSLocalizedString("Male", comment: "")
        self.femaleLabel.text = NSLocalizedString("Female", comment: "")
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "Username")
        self.emailTextField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.birthdayField.placeholder = NSLocalizedString("birthday", comment: "birthday")
//        self.usernameTextField.selectedTitle = NSLocalizedString("Username", comment: "Username")
//        self.emailTextField.selectedTitle = NSLocalizedString("Email", comment: "Email")
        maleRadioBtn.setImage(R.image.ic_radio_on(), for: .normal)
        self.title = NSLocalizedString("My Account", comment: "My Account")
        self.navigationController?.navigationItem.title = NSLocalizedString("My Account", comment: "My Account")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let Save = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: Selector("Save"))
        self.navigationItem.rightBarButtonItem = Save
    }
    private func updateMyAccount(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let email = emailTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let genderbind = self.gender ?? ""
        
        Async.background({
            SettingsManager.instance.updateMyAccount(session_Token: sessionToken, email: email, username: username, gender: genderbind, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
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
    private func showData(){
        self.usernameTextField.text = AppInstance.instance.userProfile?.username ?? ""
        self.emailTextField.text = AppInstance.instance.userProfile?.email ?? ""
        self.birthdayField.text = AppInstance.instance.userProfile?.birthday ?? ""
        if AppInstance.instance.userProfile?.genderText == "Male" || AppInstance.instance.userProfile?.genderText == "male"{
            maleRadioBtn.setImage(R.image.ic_radio_on(), for: .normal)
            femaleRadioBtn.setImage(R.image.ic_radio_off(), for: .normal)
            
        }else{
            maleRadioBtn.setImage(R.image.ic_radio_off(), for: .normal)
            femaleRadioBtn.setImage(R.image.ic_radio_on(), for: .normal)
        }
    }

    @objc func Save(){
        log.verbose("savePressed!!")
        self.updateMyAccount()
    }

}
