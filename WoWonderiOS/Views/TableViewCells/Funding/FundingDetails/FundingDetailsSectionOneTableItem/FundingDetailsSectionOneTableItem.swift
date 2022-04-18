
import UIKit
import LinearProgressBar
import WoWonderTimelineSDK
import Braintree
import ZKProgressHUD
import Paystack
class FundingDetailsSectionOneTableItem: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: LinearProgressBar!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var contactBtn: RoundButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var donateBtn: RoundButton!
    @IBOutlet weak var shareBtn: RoundButton!
    
    
    var hashID:String? = ""
    var userId = ""
    var braintree: BTAPIClient?
    var braintreeClient: BTAPIClient?
    var donationAmount = 0
    
    var fund_id = 0
    
    let paymentTextField = PSTCKPaymentCardTextField()

    
    var vc:ShowFundingDetailsVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.donateBtn.setTitle(NSLocalizedString("DONATE", comment: "DONATE"), for: .normal)
        self.shareBtn.setTitle(NSLocalizedString("SHARE", comment: "SHARE"), for: .normal)
        self.contactBtn.setTitle(NSLocalizedString("Contact", comment: "Contact"), for: .normal)
        self.donateBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.shareBtn.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.shareBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.amountLabel.textColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.contactBtn.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.contactBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
//        paymentTextField.frame = CGRectMake(15, 15, (self.vc?.view.frame)!.width - 30, 44)
          paymentTextField.delegate = self
        self.vc?.view.addSubview(paymentTextField)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func bind(_ object:GetFundingModel.Datum,index:Int){
        var names = ""
        var isPro = ""
        var isVerified = ""
        self.fund_id = object.id ?? 0
        names = object.userData?.username ?? ""
//        self.isPro = object.userData
        self.userId = "\(object.userID)"
        self.titleLabel.text = object.title ?? ""
        self.descriptionLabel.text = object.datumDescription ?? ""
        self.amountLabel.text = "$\(object.raised ?? 0).00"
        self.totalAmountLabel.text = "$\(object.amount ?? "").00"
//        let epocTime = TimeInterval(Int(object.time ?? "") ?? 1601815559)
//        let myDate = NSDate(timeIntervalSince1970: epocTime)
//        let formate = DateFormatter()
//        formate.dateFormat = "yyyy-MM-dd"
//        let dat = formate.string(from: myDate as Date)
//        print("Date",dat)
//        print("Converted Time \(myDate)")
//        self.timeLabel.text = "\(dat)"
        
        
            let epocTime = TimeInterval(Int(object.time ?? "") ?? 1601815559)
            let myDate =  Date(timeIntervalSince1970: epocTime)
            let formate = DateFormatter()
            formate.dateFormat = "yyyy-MM-dd"
            self.timeLabel.text = myDate.timeAgoDisplay()

        self.progressBar.barColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor) 
        self.progressBar.progressValue = CGFloat(object.bar ?? 0)
        
        let url = URL(string: object.image ?? "")
        self.thumImage.kf.setImage(with: url)
        let profileURL = URL(string: object.userData?.avatar ?? "")
        self.profileImage.kf.setImage(with: profileURL)
        let epocTimes = TimeInterval(Int(object.userData?.lastseen ?? "") ?? 1601815559)
        let myDates =  Date(timeIntervalSince1970: epocTimes)
        let formates = DateFormatter()
        formates.dateFormat = "yyyy-MM-dd"
        self.lastSeenLabel.text = myDates.timeAgoDisplay()
        
        
        self.hashID = object.hashedID ?? ""
        if object.userID == Int(UserData.getUSER_ID()!) {
            self.contactBtn.isHidden = true
        }else{
            self.contactBtn.isHidden = false
        }
        let imageAttachment =  NSTextAttachment()
        let imageAttachment1 =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"veirfied")
        imageAttachment1.image = UIImage(named: "flash-1")
        let imageOffsetY: CGFloat = -2.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        imageAttachment1.bounds = CGRect(x: 0, y: imageOffsetY, width: 11.0, height: 14.0)
        let attechmentString = NSAttributedString(attachment: imageAttachment)
        let attechmentString1 = NSAttributedString(attachment: imageAttachment1)
        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString1 = NSMutableAttributedString(string: names, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(attributedString: attechmentString)
        let attributedString4 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString5 = NSMutableAttributedString(attributedString: attechmentString1)
        attributedString1.append(attributedString2)
        if (isVerified == "1") && (isPro == "1"){
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            attributedString1.append(attributedString5)
        }
        else if (isVerified == "1"){
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
        }
        else if (isPro == "1"){
            attributedString1.append(attributedString5)
        }
        self.usernameLabel.attributedText = attributedString1
        
    }
    @IBAction func contactPressed(_ sender: Any) {
        let appURLScheme = "AppToOpen://userId=\(self.userId)"
        guard let appURL = URL(string: appURLScheme) else {
            return
        }
        if UIApplication.shared.canOpenURL(appURL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
        else {
            self.vc?.view.makeToast("Please install Chats App")
        }
    }
    @IBAction func sharePressed(_ sender: Any) {
        self.shareAcitvity()
    }
    
    @IBAction func donatePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Funding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EnterAmountVC") as! EnterAmountController
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.vc?.present(vc, animated: true, completion: nil)
    }
    private func shareAcitvity(){
        let string = "\(self.descriptionLabel.text!)\n\(APIClient.baseURl)//show_fund/\(self.hashID ?? "")"
//        let myWebsite = NSURL(string:"https://globalhitsradio.com/")
//        let shareAll = [ myWebsite]
//        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self
//        self.vc!.present(activityViewController, animated: true, completion: nil)
        
        let text = string
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
        self.vc!.present(activityViewController, animated: true, completion: nil)
    }
    func startCheckout() {
              // Example: Initialize BTAPIClient, if you haven't already
              braintreeClient = BTAPIClient(authorization: ControlSettings.paypalAuthorizationToken)!
              let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
              payPalDriver.viewControllerPresentingDelegate = self
              payPalDriver.appSwitchDelegate = self // Optional
              
              // Specify the transaction amount here. "2.32" is used in this example.
//           let request = BTPayPalRequest(amount: "\(30.0  ?? 0.0)")
              let request = BTPayPalRequest(amount: "\(self.donationAmount)")
              request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
              payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
                  if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                      print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                      let email = tokenizedPayPalAccount.email
                      let firstName = tokenizedPayPalAccount.firstName
                      let lastName = tokenizedPayPalAccount.lastName
                      let phone = tokenizedPayPalAccount.phone
                      let billingAddress = tokenizedPayPalAccount.billingAddress
                      let shippingAddress = tokenizedPayPalAccount.shippingAddress
                   
                  } else if let error = error {
                      print("error = \(error.localizedDescription ?? "")")
                  } else {
                      print("error = \(error?.localizedDescription ?? "")")
                      
                  }
              }
          }
   
    func gotoBankTransfer(){
        let storyboard = UIStoryboard(name: "Funding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
//        self.vc?.present(vc, animated: true, completion: nil)
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func donateFund(id:Int,amount:Int){
        FundingDonateManager.sharedInstance.fundingDonate(id: id, amount: amount) { (success, authError, error) in
            if (success != nil){
                self.vc?.view.makeToast(success?.message)
            }
            else if (authError != nil){
                self.vc?.view.makeToast(authError?.errors?.errorText)
            }
            else if (error != nil){
                self.vc?.view.makeToast(error?.localizedDescription)
            }
        }
        
    }
}


extension FundingDetailsSectionOneTableItem: paystackDelegate{
    func sendEmail(email: String) {
        let storyboard = UIStoryboard(name: "Funding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PayStackVC") as! PaystackController
//        vc.delegate = self
        vc.email = email
        vc.amount = self.donationAmount
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    
}
extension FundingDetailsSectionOneTableItem: PSTCKPaymentCardTextFieldDelegate{
//    func paymentCardTextFieldDidChange(textField: PSTCKPaymentCardTextField) {
//        // Toggle navigation, for example
////        saveButton.enabled = textField.isValid
//    }
    
}

extension FundingDetailsSectionOneTableItem: sendDonationDelegation{
    func sendAmount(amount: Int) {
        print(amount)
        if amount > 500 {
            self.vc?.view.makeToast("You can't donate more than $500.00")
        }
        else{
            self.donationAmount = amount
            let storyboard = UIStoryboard(name: "Funding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectPaymentVC") as! SelectPaymentVC
            vc.delegate = self
            if (ControlSettings.showPaymentVC == true){
                self.vc?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
extension FundingDetailsSectionOneTableItem:didSelectPaymentTypeDelegate{
    func didSelectPaymentType(typeString: String, index: Int) {
        if index == 0{
            self.startCheckout()
        }
        else if index == 1{
            let storyboard = UIStoryboard(name: "Funding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PaystackEmailVC") as! PaystackEmailController
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.vc?.present(vc, animated: true, completion: nil)
        }
        else if index == 2{
            gotoBankTransfer()
        }
    }
}

extension FundingDetailsSectionOneTableItem:BTAppSwitchDelegate, BTViewControllerPresentingDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        ZKProgressHUD.show()
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        print("Switched")
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        ZKProgressHUD.dismiss()
      print("Switched")
    }
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        viewController.present(viewController, animated: true, completion: nil)
        
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true) {
            self.donateFund(id: self.fund_id, amount: self.donationAmount)
//            self.donateFund(id: <#T##Int#>, amount: <#T##Int#>)
        }
    }
    
}
