
import UIKit
import WoWonderTimelineSDK
import GoogleMobileAds
////import FBAudienceNetwork

class SelectCategoryVC: UIViewController {
    
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var index:Int? = 0;
    var delegate:GenderDelegate!
    private var selectArray = [String]()
    
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
        
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupUI(){
        self.showView.layer.cornerRadius = 10
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
      tableView.register( R.nib.selectCategoryTableCell(), forCellReuseIdentifier: R.reuseIdentifier.selectCategory_TableCell.identifier)
        if index == 0{
            self.selectArray = ["All","Male","Female"]
            self.titleLabel.text = "Gender"
            
        }else if index == 1{
            self.selectArray = ["All","Yes","No"]
            self.titleLabel.text = "Profile Picture"
            
        }else{
            self.selectArray = ["All","Offline","Online"]
            self.titleLabel.text = "Status"
            
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
    
}
extension SelectCategoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectCategory_TableCell.identifier) as? SelectCategory_TableCell
        cell?.titleLabel.text = self.selectArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.selectGender(text: selectArray[indexPath.row], Index: index ?? 0)
        self.dismiss(animated: true, completion: nil)
    }
    
}

//extension SelectCategoryVC:FBInterstitialAdDelegate{
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
