
import UIKit
import DropDown
import Async
import WoWonderTimelineSDK
import GoogleMobileAds
////import FBAudienceNetwork

class FollowingVC: BaseVC {
    
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var noFollowersLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchRandomBtn: UIButton!
    @IBOutlet weak var showStackImage: UIImageView!
//    @IBOutlet weak var moreBtn: UIBarButtonItem!
    
    private let moreDropdown = DropDown()
    private var followingsArray = [FollowingModel.Following]()
    private  var refreshControl = UIRefreshControl()
    private let color = UIColor.ButtonColor
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!

    
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
        setupUI()
        self.fetchData()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        
        let vc = R.storyboard.dashboard.searchRandomVC()
        vc?.statusIndex = 0
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func morePressed(_ sender: Any) {
        self.moreDropdown.show()
    }
    @IBAction func searchRandomPressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.searchRandomVC()
        vc?.statusIndex = 1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupUI(){
        self.showStackImage.tintColor = .mainColor
        self.searchRandomBtn.backgroundColor = .ButtonColor
        self.title = NSLocalizedString("Following", comment: "Following")
        self.navigationController?.navigationItem.title = NSLocalizedString("Following", comment: "Following")
        self.noFollowersLabel.text = NSLocalizedString("There are no Contacts", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start adding new contact !!", comment: "")
        self.searchRandomBtn.setTitle(NSLocalizedString("Search Random", comment: ""), for: .normal)
        self.showStackImage.isHidden = true
        self.showStack.isHidden = true
        searchRandomBtn.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register( R.nib.followingsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.followings_TableCell.identifier)
        customizeDropdown()
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
//
    @objc func refresh(sender:AnyObject) {
        self.followingsArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Invite Friends", comment: "Invite Friends"),NSLocalizedString("Refresh", comment: "Refresh"),NSLocalizedString("Block User List", comment: "Block User List")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
//        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                let vc = R.storyboard.dashboard.inviteFriendsVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if index == 1{
                
                self.fetchData()
            }else{
                let vc = R.storyboard.dashboard.blockedUsersVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            print("Index = \(index)")
        }
        
    }
    private func fetchData(){
        self.followingsArray.removeAll()
        self.tableView.reloadData()
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        Async.background({
            FollowingManager.instance.getFollowings(user_id: AppInstance.instance.userId ?? "", session_Token: AppInstance.instance.sessionId ?? "", fetch_type: "following") { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.following ?? nil)")
                            if (success?.following?.isEmpty)!{
                                self.showStackImage.isHidden = false
                                self.showStack.isHidden = false
                                self.searchRandomBtn.isHidden = false
                                self.tableView.isHidden = true
                                self.refreshControl.endRefreshing()
                            }else {
                                self.tableView.isHidden = false
                                self.showStackImage.isHidden = true
                                self.showStack.isHidden = true
                                self.searchRandomBtn.isHidden = true
                                self.followingsArray = success?.following ?? []
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
            }
            
        })
        
    }
    
}



extension FollowingVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followingsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.followings_TableCell.identifier) as? Followings_TableCell
        let object = followingsArray[indexPath.row]
        cell?.selectionStyle = .none
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        cell?.userId  = object.userID ?? ""
        if object.firstName ?? "" == "" && object.lastName ?? "" == ""{
            cell?.usernameLabel.text = "\(object.username ?? "")"
        }else{
            cell?.usernameLabel.text = "\(object.firstName ?? "") \(object.lastName ?? "")" ?? "\(object.username ?? "")"
        }
      
        cell?.timeLabel.text = ControlSettings.WoWonderText
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72;
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
        let object = followingsArray[indexPath.row]
        let chatColor = UserDefaults.standard.getChatColorHex(Key: Local.CHAT_COLOR_HEX.ChatColorHex)
        let Storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileController
        vc.userData = object
        //let vc = R.storyboard.chat.chatScreenVC()
       // vc?.recipientID = object.userID
       // vc!.followingUserObject = object
       // vc?.chatColorHex = chatColor
        self.navigationController?.pushViewController(vc, animated: true)
        log.verbose("To followUser id = \(object.userID ?? "")")
    }
    
}
extension FollowingVC:FollowUnFollowDelegate{
    
    func followUnfollow(user_id: String, index: Int, cellBtn: UIButton) {
        
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            FollowingManager.instance.followUnfollow(user_id: user_id, session_Token: sessionToken, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.followStatus ?? "")")
                            self.view.makeToast(success?.followStatus ?? "")
                            if success?.followStatus  ?? "" == "followed"{
                                cellBtn.backgroundColor = self.color
                                cellBtn.setTitleColor(UIColor.white, for: .normal)
                                if (AppInstance.instance.connectivity_setting == "0"){
                                    self.followingsArray[index].isFollowing = 1
                                    cellBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                                }
                                else{
                                    if (self.followingsArray[index].isFollowing == 0){
                                        cellBtn.backgroundColor = UIColor.white
                                        cellBtn.borderColorV = self.color
                                        cellBtn.borderWidthV = 2
                                        cellBtn.setTitleColor(self.color, for: .normal)
                                        self.followingsArray[index].isFollowing = 2
                                        cellBtn.setTitle(NSLocalizedString("Requested", comment: "Requested"), for: .normal)
                                    }
                                    else{
                                        self.followingsArray[index].isFollowing = 1
                                        cellBtn.setTitle(NSLocalizedString("MyFriend", comment: "MyFriend"), for: .normal)
                                    }
                                }

                                
                            }else{
                                cellBtn.backgroundColor = UIColor.white
                                cellBtn.borderColorV = self.color
                                cellBtn.borderWidthV = 2
                                cellBtn.setTitleColor(self.color, for: .normal)
                                if (AppInstance.instance.connectivity_setting == "0"){
                                     self.followingsArray[index].isFollowing = 0
                                     cellBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
                                }
                                else{
                                      self.followingsArray[index].isFollowing = 0
                                      cellBtn.setTitle(NSLocalizedString("AddFriend", comment: "AddFriend"), for: .normal)
                                }
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

//extension FollowingVC :FBInterstitialAdDelegate{
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



