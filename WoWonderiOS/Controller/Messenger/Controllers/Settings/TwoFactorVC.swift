

import UIKit
import GoogleMobileAds
import Async

protocol TwoFactorAuthDelegate {
    func getTwoFactorUpdateString(type:String)
}

class TwoFactorVC: BaseVC {
    
    
    @IBOutlet weak var selectBtn: UIButton!
    var bannerView: GADBannerView!
    
    @IBOutlet weak var twoFactorLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    
    
    var typeString:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
        self.saveBtn.backgroundColor = .ButtonColor
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Two Factor Authentication"
        
        
        self.twoFactorLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
        self.textLabel.text = NSLocalizedString("Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.", comment: "Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.")
        self.saveBtn.setTitle(NSLocalizedString("SAVE", comment: "SAVE"), for: .normal)
        
        self.typeString = self.selectBtn.titleLabel?.text ?? ""
        if AppInstance.instance.userProfile?.twoFactor == "0"{
            self.selectBtn.setTitle(NSLocalizedString("Disable", comment: "Disable"), for: .normal)
        }else{
            self.selectBtn.setTitle(NSLocalizedString("Enable", comment: "Enable"), for: .normal)
        }
        if ControlSettings.shouldShowAddMobBanner{

            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }
    
    @IBAction func selectBtnPressed(_ sender: Any) {
        let vc = R.storyboard.settings.twoFactorUpdateVC()
        vc!.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    @IBAction func savePressed(_ sender: Any) {
        self.showProgressDialog(text: "Loading")
        
        if typeString == "on"{
            self.updateTwoFactorSendCode()
        }else{
            self.updateTwoFactor()
        }
        
    }
    private func updateTwoFactor(){
        let type = self.typeString ?? ""
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            SettingsManager.instance.updateTwoStepVerification(session_Token: sessionToken, type: type) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                           AppInstance.instance.fetchUserProfile(pass: nil)
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
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
    private func updateTwoFactorSendCode(){
        self.showProgressDialog(text: "Loading")
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            TwoFactorManager1.instance.updateTwoFactor(session_Token: sessionToken) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            let vc = R.storyboard.settings.confirmationCodeVC()
                            self.present(vc!, animated: true, completion: nil)
                            
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
extension TwoFactorVC:TwoFactorAuthDelegate{
    func getTwoFactorUpdateString(type: String) {
        if type == "on"{
            self.selectBtn.setTitle("Enable", for: .normal)
        }else{
            self.selectBtn.setTitle("Disable", for: .normal)
        }
        self.typeString = type
    }
}


