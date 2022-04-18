
import UIKit
import XLPagerTabStrip
import SwiftEventBus
import WoWonderTimelineSDK
////import FBAudienceNetwork
import GoogleMobileAds

class CallVC: UIViewController {
    
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var noCallsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var phoneImage: UIImageView!
    
    @IBOutlet weak var phoneBtn: UIButton!
    private var callLogArray = [CallLogsModel]()
    private  var refreshControl = UIRefreshControl()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneBtn.backgroundColor = .ButtonColor
           self.phoneImage.tintColor = .mainColor
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
        SwiftEventBus.postToMainThread("settings", sender: 2)
    }
    private func fetchData(){
         self.callLogArray.removeAll()
        self.tableView.reloadData()
        let getCallLogsData = UserDefaults.standard.getCallsLogs(Key: Local.CALL_LOGS.CallLogs)
        if (getCallLogsData.isEmpty){
            
            self.phoneImage.isHidden = false
            self.showStack.isHidden = false
            self.refreshControl.endRefreshing()
        }else {
            self.phoneImage.isHidden = true
            self.showStack.isHidden = true
            getCallLogsData.forEach { (singleLog) in
                let result = try! PropertyListDecoder().decode(CallLogsModel.self, from: singleLog)
                self.callLogArray.append(result)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
//        if ControlSettings.shouldShowAddMobBanner{
//
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
    @IBAction func selectContactPressed(_ sender: Any) {
        
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
        let vc = R.storyboard.dashboard.selectContactVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func setupUI(){
   
        self.noCallsLabel.text = NSLocalizedString("No Calls", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start a new call from your friends list by pressing the button at the bottom of the screen.", comment: "")
        self.phoneImage.isHidden = true
        self.showStack.isHidden = true
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.callsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.calls_TableCell.identifier)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject) {
        self.callLogArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    
    
}
extension CallVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLogArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.calls_TableCell.identifier) as? Calls_TableCell
        let object = callLogArray[indexPath.row]
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        cell?.usernameLabel.text = object.name ?? ""
        cell?.callLogLabel.text = object.logText ?? ""
        let url = URL.init(string:object.profilePicture ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension CallVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("CALLS", comment: "CALLS"))
    }
    
    
    
}
extension CallVC:SelectContactCallsDelegate{
    func selectCalls(index: Int, type: String) {
        
        let vc = R.storyboard.call.agoraCallNotificationPopupVC()
        vc?.callingType = "calling..."
        vc?.callingStatus = "audio"
        vc?.callLogUserObject = callLogArray[index]
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
    }
    
}
extension CallVC:CallReceiveDelegate{
    func receiveCall(callId: Int, RoomId: String, callingType: String, username: String, profileImage: String, accessToken: String?) {
        let vc  = R.storyboard.call.agoraCallVC()
        vc?.callId = callId
        vc?.roomID = RoomId
        vc?.usernameString = username
        vc?.profileImageUrlString = profileImage
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    
}

//extension CallVC:FBInterstitialAdDelegate{
//    
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
