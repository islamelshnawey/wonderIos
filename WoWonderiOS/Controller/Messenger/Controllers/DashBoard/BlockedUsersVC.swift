

import UIKit
import Async
import SwiftEventBus
import WoWonderTimelineSDK
import GoogleMobileAds
////import FBAudienceNetwork

class BlockedUsersVC: BaseVC {
    @IBOutlet weak var noBlockLabel: UILabel!
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var blockeduserImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var blockedUsersArray = [GetBlockedUsersModel.BlockedUser]()
    private  var refreshControl = UIRefreshControl()
    private var fetchSatus:Bool? = true
    //Ads
    //Google Ads
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
            
            
        }
        
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
        }
        
    }
    deinit{
        SwiftEventBus.unregister(self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupUI(){
        self.blockeduserImage.tintColor = .mainColor
        self.noBlockLabel.text = NSLocalizedString("There is no blocked Users", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start Blocking Users", comment: "")
        self.blockeduserImage.isHidden = true
        self.showStack.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = NSLocalizedString("Blocked Users", comment: "Blocked Users")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.blockedUsersTableCell(), forCellReuseIdentifier: R.reuseIdentifier.blockedUsers_TableCell.identifier)
//        if ControlSettings.shouldShowAddMobBanner{
//
//
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//
//        }
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.blockedUsersArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
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
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        }else{
            log.verbose("will not show Hud more...")
        }
        
        self.blockedUsersArray.removeAll()
        let sessionToken = AppInstance.instance.sessionId ?? ""
        
        Async.background({
            BlockUsersManager1.instanc.getBlockedUsers(session_Token: sessionToken, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.blockedUsers ?? nil)")
                            if (success?.blockedUsers?.isEmpty)!{
                                
                                self.blockeduserImage.isHidden = false
                                self.showStack.isHidden = false
                                self.refreshControl.endRefreshing()
                            }else {
                                self.blockeduserImage.isHidden = true
                                self.showStack.isHidden = true
                                self.blockedUsersArray = (success?.blockedUsers) ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            
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
                
            })
            
            
            
        })
        
    }
}
extension BlockedUsersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockedUsersArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blockedUsers_TableCell.identifier) as? BlockedUsers_TableCell
        let object = blockedUsersArray[indexPath.row]
        cell?.usernameLabel.text = object.username ?? ""
        cell?.lastSeenLabel.text = "\(NSLocalizedString("Last seen", comment: "Last seen"))\(" ")\(object.lastseenTimeText ?? "")"
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
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
                interstitial.present(fromRootViewController: self)
                    interstitial = CreateAd()
                    AppInstance.instance.addCount = 0
            }
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        let vc = R.storyboard.dashboard.blockedUsersPopupVC()
        let blockedUsersObject = blockedUsersArray[indexPath.row]
        vc?.blockedUserObject = blockedUsersObject
        self.present(vc!, animated: true, completion: nil)
    }
    
}

//extension BlockedUsersVC:FBInterstitialAdDelegate{
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
