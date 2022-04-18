
import UIKit
import Async
import WoWonderTimelineSDK
import GoogleMobileAds
////import FBAudienceNetwork

class SelectContactVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private  var refreshControl = UIRefreshControl()
    private var selectContactArray = [SelectContactModel.User]()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
        // Do any additional setup after loading the view.
    }
    func setupUI(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = "Select Contact"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.selectContactTableCell(), forCellReuseIdentifier: R.reuseIdentifier.selectContact_TableCell.identifier)
        log.verbose("AppInstance.instance.userId = \(AppInstance.instance.userId)")
        log.verbose("AppInstance.instance.sessionId = \(AppInstance.instance.sessionId)")
       if ControlSettings.shouldShowAddMobBanner{

                   bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                   addBannerViewToView(bannerView)
                   bannerView.adUnitID = ControlSettings.addUnitId
                   bannerView.rootViewController = self
                   bannerView.load(GADRequest())


               }
               
    }
    @objc func refresh(sender:AnyObject) {
        self.selectContactArray.removeAll()
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
    private func fetchData(){
        
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        Async.background({
            SelectContactManger.instance.getContactList(user_id: AppInstance.instance.userId ?? "", session_Token: AppInstance.instance.sessionId ?? "",  list_type: "all") { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.users ?? nil)")
                                self.selectContactArray = (success?.users)!
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
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
    
   
}
extension SelectContactVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectContactArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectContact_TableCell.identifier) as? SelectContact_TableCell
        let object = self.selectContactArray[indexPath.row]
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        cell?.usernameLabel.text = object.username ?? ""
        cell?.titleLabel.text = object.userPlatform ?? ""
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension SelectContactVC:SelectContactCallsDelegate{
    func selectCalls(index: Int, type: String) {
        if type == "video"{
            let vc = R.storyboard.call.agoraCallNotificationPopupVC()
            vc?.callingType = "calling Video..."
            vc?.callingStatus = "video"
            vc?.delegate = self
            vc?.contactUserObject = selectContactArray[index]
            self.present(vc!, animated: true, completion: nil)
        }else{
            let vc = R.storyboard.call.agoraCallNotificationPopupVC()
            vc?.callingType = "calling..."
            vc?.callingStatus = "audio"
            vc?.contactUserObject = selectContactArray[index]
            vc?.delegate = self
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    
}
extension SelectContactVC:CallReceiveDelegate{
    func receiveCall(callId: Int, RoomId: String, callingType: String, username: String, profileImage: String, accessToken: String?) {
        if callingType == "video"{
            let vc  = R.storyboard.call.videoCallVC()
            vc?.callId = callId
            vc?.roomID = RoomId
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc  = R.storyboard.call.agoraCallVC()
            vc?.callId = callId
            vc?.roomID = RoomId
            vc?.usernameString = username
            vc?.profileImageUrlString = profileImage
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
   
}

//extension SelectContactVC :FBInterstitialAdDelegate{
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

