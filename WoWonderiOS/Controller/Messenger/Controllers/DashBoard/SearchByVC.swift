
import UIKit
import WoWonderTimelineSDK
import GoogleMobileAds
//import FBAudienceNetwork

class SearchByVC: UIViewController {
    
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    //Ads
    //Google Ads
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    @IBAction func genderPressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.selectCategoryVC()
        vc?.index = 0
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func profilePicturePressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.selectCategoryVC()
        vc?.index = 1
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    @IBAction func statusPressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.selectCategoryVC()
        vc?.index = 2
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    func setupUI(){
        self.gLabel.text = NSLocalizedString("Gender", comment: "")
        self.pLabel.text = NSLocalizedString("Profile Picture", comment: "")
        self.sLabel.text = NSLocalizedString("Status", comment: "")
        self.genderLabel.text = AppInstance.instance.genderText ?? "All"
        self.profilePictureLabel.text = AppInstance.instance.profilePicText ?? "All"
        self.statusLabel.text = AppInstance.instance.statusText ?? "All"
        genderLabel.layer.borderWidth = 0.5
        genderLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "B3B3B3").cgColor
        genderLabel.layer.cornerRadius = 5
        
        profilePictureLabel.layer.borderWidth = 0.5
        profilePictureLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "B3B3B3").cgColor
        profilePictureLabel.layer.cornerRadius = 5
        
        statusLabel.layer.borderWidth = 0.5
        statusLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "B3B3B3").cgColor
        statusLabel.layer.cornerRadius = 5
        
        let Save = UIBarButtonItem(title: "Save", style: .done, target: self, action: Selector("Save"))
        self.navigationItem.rightBarButtonItem = Save
        
        
    }
    @objc func Save(){
        print("Saved Pressed!!")
    }
    
    
}
extension SearchByVC:GenderDelegate{
    func selectGender(text: String, Index: Int) {
        if Index == 0{
            self.genderLabel.text = text
            AppInstance.instance.genderText = self.genderLabel.text
            
        }else if Index == 1{
            self.profilePictureLabel.text = text
            AppInstance.instance.profilePicText = self.profilePictureLabel.text
        }else{
            self.statusLabel.text = text
            AppInstance.instance.statusText = self.statusLabel.text
        }
    }
}

//extension SearchByVC:FBInterstitialAdDelegate{
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
