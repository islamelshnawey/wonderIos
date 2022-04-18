

import UIKit
import XLPagerTabStrip
import SwiftEventBus
import WoWonderTimelineSDK
import Async
import GoogleMobileAds
////import FBAudienceNetwork

class GroupVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var noGroupChatImage: UIImageView!
    
    @IBOutlet weak var addBtn: UIButton!
    private  var refreshControl = UIRefreshControl()
    private var fetchSatus:Bool? = true
    private var groupChatRequestArray = [GroupRequestModel.GroupChatRequest]()
    private var groupsArray = [FetchGroupModel.Datum]()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!

    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
//            self.fetchData()
//        }
        self.fetchData()
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
        }
        
//        if ControlSettings.shouldShowAddMobBanner{
//
//            if ControlSettings.googleAds {
//                interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//                let request = GADRequest()
//                interstitial.load(request)
//                interstitial.delegate = self
//            }else if ControlSettings.facebookAds{
//                loadFullViewAdd()
//            }
//
//        }
    }
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    @IBAction func addGroupPressed(_ sender: Any) {
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
        
        let vc = R.storyboard.group.createGroupVC()
        self.navigationController?.pushViewController(vc!, animated: true)
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
    func setupUI(){
        self.addBtn.backgroundColor = .ButtonColor
         self.noGroupChatImage.tintColor = .mainColor
        self.tableView.isHidden = true
        self.noMessagesLabel.text = NSLocalizedString("No more Messages", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start new conversations by going to contact", comment: "")
        self.noGroupChatImage.isHidden = true
        self.showStack.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.groupTableCell(), forCellReuseIdentifier: R.reuseIdentifier.group_TableCell.identifier)
        tableView.register( R.nib.groupRequestTableCell(), forCellReuseIdentifier: R.reuseIdentifier.groupRequest_TableCell.identifier)
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.groupsArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
        
    }
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        }else{
            log.verbose("will not show Hud more...")
        }
        
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            GroupChatManager.instance.fetchGroups(session_Token: sessionToken, type: "get_list", limit: 10
                , completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.data ?? nil)")
                                if (success?.data?.isEmpty)!{
                                    
                                    self.noGroupChatImage.isHidden = false
                                    self.showStack.isHidden = false
                                    self.tableView.isHidden = true
                                    self.refreshControl.endRefreshing()
                                }else {
                                    self.noGroupChatImage.isHidden = true
                                    self.showStack.isHidden = true
                                    self.tableView.isHidden = false
                                    self.groupsArray = (success?.data) ?? []
                                    
                                    self.tableView.reloadData()
                                    self.refreshControl.endRefreshing()
                                }
                                self.fetchGroupRequest()
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
    private func fetchGroupRequest(){
        
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            GroupRequestManager.instance.fetchGroupRequest(session_Token: sessionToken, fetchType: "group_chat_requests", offset: 1, setOnline: 1) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.groupChatRequests ?? nil)")
                            self.groupChatRequestArray = success?.groupChatRequests ?? []
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
    func setTimestamp(epochTime: String) -> String {
           let currentDate = Date()
           
           let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
           
           let calendar = Calendar.current
           
           let currentDay = calendar.component(.day, from: currentDate)
           let currentHour = calendar.component(.hour, from: currentDate)
           let currentMinutes = calendar.component(.minute, from: currentDate)
           let currentSeconds = calendar.component(.second, from: currentDate)
           
           let epochDay = calendar.component(.day, from: epochDate)
           let epochMonth = calendar.component(.month, from: epochDate)
           let epochYear = calendar.component(.year, from: epochDate)
           let epochHour = calendar.component(.hour, from: epochDate)
           let epochMinutes = calendar.component(.minute, from: epochDate)
           let epochSeconds = calendar.component(.second, from: epochDate)
           
           if (currentDay - epochDay < 30) {
               if (currentDay == epochDay) {
                   if (currentHour - epochHour == 0) {
                       if (currentMinutes - epochMinutes == 0) {
                           if (currentSeconds - epochSeconds <= 1) {
                               return String(currentSeconds - epochSeconds) + " second ago"
                           } else {
                               return String(currentSeconds - epochSeconds) + " seconds ago"
                           }
                           
                       } else if (currentMinutes - epochMinutes <= 1) {
                           return String(currentMinutes - epochMinutes) + " minute ago"
                       } else {
                           return String(currentMinutes - epochMinutes) + " minutes ago"
                       }
                   } else if (currentHour - epochHour <= 1) {
                       return String(currentHour - epochHour) + " hour ago"
                   } else {
                       return String(currentHour - epochHour) + " hours ago"
                   }
               } else if (currentDay - epochDay <= 1) {
                   return String(currentDay - epochDay) + " day ago"
               } else {
                   return String(currentDay - epochDay) + " days ago"
               }
           } else {
               return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
           }
       }
       
       
       func getMonthNameFromInt(month: Int) -> String {
           switch month {
           case 1:
               return "Jan"
           case 2:
               return "Feb"
           case 3:
               return "Mar"
           case 4:
               return "Apr"
           case 5:
               return "May"
           case 6:
               return "Jun"
           case 7:
               return "Jul"
           case 8:
               return "Aug"
           case 9:
               return "Sept"
           case 10:
               return "Oct"
           case 11:
               return "Nov"
           case 12:
               return "Dec"
           default:
               return ""
           }
       }
}
extension GroupVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.groupsArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.groupRequest_TableCell.identifier) as? GroupRequest_TableCell
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.group_TableCell.identifier) as? Group_TableCell
        
        let object = self.groupsArray[indexPath.row]
        cell?.groupNameLabel.text = object.groupName ?? ""
        log.verbose("group ID = \(object.groupID)")
        let datefromtTime = convertDate(Unix: Double(object.chatTime ?? "0.0") as! Double)
        cell?.lastSeenLabel.text =  setTimestamp(epochTime: object.chatTime!)
        
        
        
        
        let url = URL.init(string:object.avatar ?? "")
        cell?.groupImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.groupImage.cornerRadiusV = (cell?.groupImage.frame.height)! / 2
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
        self.tableView.deselectRow(at: indexPath, animated: true)
//        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
        if indexPath.section == 0{
            let vc = R.storyboard.group.groupRequestVC()
            vc!.groupsArray = self.groupChatRequestArray
            self.navigationController?.pushViewController(vc!, animated: true)   
        }else{
            let vc = R.storyboard.group.groupChatScreenVC()
            vc!.parts = self.groupsArray[indexPath.row].parts!
            vc?.recipientID = self.groupsArray[indexPath.row].userData?.userID ?? ""
            vc?.groupId = self.groupsArray[indexPath.row].groupID ?? ""
            vc?.groupname = self.groupsArray[indexPath.row].groupName ?? ""
            vc?.groupImage = self.groupsArray[indexPath.row].avatar ?? ""
            vc?.groupOBject = self.groupsArray[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    
}

//extension GroupVC :FBInterstitialAdDelegate{
//
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

extension GroupVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("GROUPS", comment: "GROUPS"))
    }  
}
