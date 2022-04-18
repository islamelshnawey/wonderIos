

import UIKit
import WoWonderTimelineSDK
import GoogleMobileAds
import MessageUI
//import FBAudienceNetwork

class InviteFriendsVC: BaseVC {
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var status:Bool? = false
    var delegate:SelectContactDetailDelegate?
    //Ads
    //Google Ads
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    var key:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchContacts()
    }
    
    @IBAction func crossPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        if status!{
            self.crossBtn.isHidden = false
        }else{
            self.crossBtn.isHidden = true
        }
        crossBtn.imageView?.image = crossBtn.imageView!.image!.withRenderingMode(.alwaysTemplate)
        crossBtn.imageView!.tintColor = UIColor.hexStringToUIColor(hex: "#a84849")
        self.title = "Invite Friends"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.inviteFriendsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.inviteFriends_TableCell.identifier)
//        if ControlSettings.shouldShowAddMobBanner{
//
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//
//        }
    }
    func CreateAd() -> GADInterstitialAd {
        
        GADInterstitialAd.load(withAdUnitID:ControlSettings.interestialAddUnitId,
                               request: GADRequest(),
                               completionHandler: { (ad, error) in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                self.interstitial = ad
                               }
        )
        return  self.interstitial
        
    }
     func sendMessageToNumber(number:String,message:String){
        if (MFMessageComposeViewController.canSendText()) {
                   let controller = MFMessageComposeViewController()
                   controller.body = message
                   controller.recipients = [number]
                   controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
               }
    }
}

extension InviteFriendsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactNameArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inviteFriends_TableCell.identifier) as? InviteFriends_TableCell
        cell?.nameLabel.text = self.contactNameArray[indexPath.row]
        cell?.numberLabel.text = self.contactNumberArray[indexPath.row]
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.instance.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if let ad = interstitial {
                    //fullScreenAd = FBInterstitialAd(placementID: ControlSettings.facebookPlacementID)
                    //fullScreenAd?.delegate = self
                    //fullScreenAd?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds{
//                interstitial.present(fromRootViewController: self)
//                    interstitial = CreateAd()
//                    AppInstance.instance.addCount = 0
            }
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        if key == "settings"{
            self.sendMessageToNumber(number: self.contactNumberArray[indexPath.row], message:ControlSettings.inviteFriendText)
        }else{
            if status!{
                let param = [self.contactNameArray[indexPath.row]:self.contactNumberArray[indexPath.row]]
                self.delegate?.selectContact(key: self.contactNameArray[indexPath.row], value: self.contactNumberArray[indexPath.row])
                self.dismiss(animated: true, completion: nil)
            }else{
                log.verbose("you are not allowed to perform any action on this activity")
                self.view.makeToast(NSLocalizedString("you are not allowed to perform any action on this activity", comment: "you are not allowed to perform any action on this activity"))
                
            }
        }
        
    }
    
}
extension InviteFriendsVC:MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
}

//extension InviteFriendsVC:FBInterstitialAdDelegate{
//    //Place your placementID here to see the Facebook ads
//    func loadFullViewAdd(){
//        //fullScreenAd = FBInterstitialAd(placementID: ControlSettings.facebookPlacementID)
//        fullScreenAd.delegate = self
//        fullScreenAd.load()
//    }
//    
//    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
//        interstitialAd.show(fromRootViewController: self)
//        print("AddLoaded")
//        
//    }
//    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
//        
//    }
//}

