
import UIKit
import WoWonderTimelineSDK
import Async
import CoreLocation
import FittedSheets
import GoogleMobileAds
//import FBAudienceNetwork

class FindFriendsVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var noUserImage: UIImageView!
    
    @IBOutlet weak var filterBtn: UIButton!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    private var userArray = [FIndFriendModel.NearbyUser]()
    private  var refreshControl = UIRefreshControl()
    private let color = UIColor.hexStringToUIColor(hex: "A84849")
    //Ads
    //Google Ads
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    var latitude:Double? = 0.0
    var longitude:Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noUserImage.tintColor = .mainColor
        self.filterBtn.backgroundColor = .ButtonColor
        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            log.verbose("Lat = \(currentLocation.coordinate.latitude)")
            log.verbose("long = \(currentLocation.coordinate.longitude)")
            self.latitude = currentLocation.coordinate.latitude
            self.longitude = currentLocation.coordinate.longitude
            
            self.fetchData(lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0 , genderString: "all", status: 2, distance: 0)
            
        }
        self.setupUI()
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
    @IBAction func filterPressed(_ sender: Any) {
        let vc  = R.storyboard.findFriends.filterVC()!
//        let controller = SheetViewController(controller:vc)
        let controller =  SheetViewController(
            controller: vc,
            sizes: [.intrinsic, .percent(0.25), .fixed(200), .fullscreen])
//        controller.blurBottomSafeArea = false
        vc.delegate = self
        self.present(controller, animated: false, completion: nil)
    }
    private func setupUI(){
        self.title = NSLocalizedString("Find Friends", comment: "")
        self.upperLabel.text = NSLocalizedString("There are no Users", comment: "")
        self.noUserImage.isHidden = true
        self.showStack.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.register( R.nib.findFriendsCollectionCell(), forCellWithReuseIdentifier: R.reuseIdentifier.findFriends_CollectionCell.identifier)
    }
    
    @objc func refresh(sender:AnyObject) {
        self.userArray.removeAll()
        self.collectionView.reloadData()
        self.fetchData(lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0 , genderString: "all", status: 2, distance: 0)
    }
    
    
    private func fetchData(lat:Double,long:Double,genderString:String,status:Int,distance:Int){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            FIndFriendManager.instance.fetchFindFriends(session_Token: sessionToken, gender: genderString, status: status, distance: distance, lat:lat, long: long, limit: 20, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.apiStatus ?? nil)")
                            if (success?.nearbyUsers?.isEmpty)!{
                                
                                self.noUserImage.isHidden = false
                                self.showStack.isHidden = false
                                self.refreshControl.endRefreshing()
                            }else {
                                self.noUserImage.isHidden = true
                                self.showStack.isHidden = true
                                self.userArray = (success?.nearbyUsers) ?? []
                                
                                self.collectionView.reloadData()
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
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    func convertDate(Unix:Double) -> Date{
        let timestamp = Unix
        
        var dateFromTimeStamp = Date(timeIntervalSinceNow: timestamp as! TimeInterval / 1000)
        return dateFromTimeStamp
        
    }
}
extension FindFriendsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.findFriends_CollectionCell.identifier, for: indexPath) as? FindFriends_CollectionCell
        
        let object = self.userArray[indexPath.row]
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        cell?.userId  = object.userID ?? ""
        cell?.userNameLabel.text = object.username ?? ""
        let datefromtTime = convertDate(Unix: Double(object.lastseen ?? "0.0") as! Double)
        cell?.timeLabel.text = timeAgoSinceDate(datefromtTime)
        let url = URL.init(string:object.avatar ?? "")
        
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        if object.lastseenStatus == "on"{
            cell?.statusView.backgroundColor = UIColor.hexStringToUIColor(hex: "#39A43E")
        }else{
            cell?.statusView.backgroundColor = UIColor.hexStringToUIColor(hex: "#ECECEC")
        }
        return cell!
}
}
extension FindFriendsVC:DidFilterDelegate{
    func filter(genderString: String, status: Int, distance: Int) {
        self.userArray.removeAll()
        self.collectionView.reloadData()
        self.fetchData(lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0, genderString: genderString, status: status, distance: distance)
    }

   
}
extension FindFriendsVC:FollowUnFollowDelegate{
    
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
                                    self.userArray[index].isFollowing = 1
                                    cellBtn.setTitle(NSLocalizedString("following", comment: "following"), for: .normal)
                                }
                                else{
                                    if (self.userArray[index].isFollowing == 0){
                                        cellBtn.backgroundColor = UIColor.white
                                        cellBtn.borderColorV = self.color
                                        cellBtn.borderWidthV = 2
                                        cellBtn.setTitleColor(self.color, for: .normal)
                                        self.userArray[index].isFollowing = 2
                                        cellBtn.setTitle(NSLocalizedString("Requested", comment: "Requested"), for: .normal)
                                    }
                                    else{
                                        self.userArray[index].isFollowing = 1
                                        cellBtn.setTitle(NSLocalizedString("MyFriend", comment: "MyFriend"), for: .normal)
                                    }
                                }

                                
                            }else{
                                cellBtn.backgroundColor = UIColor.white
                                cellBtn.borderColorV = self.color
                                cellBtn.borderWidthV = 2
                                cellBtn.setTitleColor(self.color, for: .normal)
                                if (AppInstance.instance.connectivity_setting == "0"){
                                     self.userArray[index].isFollowing = 0
                                     cellBtn.setTitle(NSLocalizedString("follow", comment: "follow"), for: .normal)
                                }
                                else{
                                      self.userArray[index].isFollowing = 0
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

//extension FindFriendsVC:FBInterstitialAdDelegate{
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
