//
//  ViewController.swift
//  News_Feed
//
//  Created by clines329 on 10/19/19.
//  Copyright © 2019 clines329. All rights reserved.

import UIKit
import AlamofireImage
import Kingfisher
import SDWebImage
import PaginatedTableView
import Toast_Swift
import ZKProgressHUD
import NVActivityIndicatorView
import WoWonderTimelineSDK
import GoogleMobileAds
import AVFoundation
//import PusherSwift

struct datas{
    let status : String
    let image : UIImage?
}

class ViewController: UIViewController,FilterBlockUser,UISearchBarDelegate,UITabBarControllerDelegate,editPostDelegate,loadEventDelegate,createLiveDelegate {
    
    func filterBlockUser(userId: String) {
        self.newsFeedArray = self.newsFeedArray.filter({$0["user_id"] as? String != userId})
        self.tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gotoTop: UIButton!
    
    
    var newsFeedArray = [[String:Any]]()
    var filterFeedArray = [[String:Any]]()
    var suggestedGroupArray = [[String:Any]]()
    var suggestedUserArray = [[String: Any]]()
    var isVideo:Bool? = false
    
    var flag = true
    
    let spinner = UIActivityIndicatorView(style: .gray)
    let pulltoRefresh = UIRefreshControl()
    var storiesArray = [GetStoriesModel.UserDataElement]()
    let status = Reach().connectionStatus()
    var interstitial: GADInterstitialAd!
    var selectedIndex = 0
    var filter = 1
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "click_sound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 40))
    let placeholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.white])
    
    var off_set = "0"
    var flagTemp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.tabBarController?.tabBar.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.gotoTop.layer.cornerRadius = 25
        self.gotoTop.isHidden = true
        self.gotoTop.backgroundColor = UIColor.hexStringToUIColor(hex: "#e5e5e5")
        
        print(UserData.getUSER_ID()!)
        print(UserData.getAccess_Token()!)
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clearButtonMode = .never
            textfield.textColor = .white
            textfield.backgroundColor = UIColor.clear
            textfield.attributedPlaceholder = NSAttributedString(string: "\(" ")\(NSLocalizedString("Search...", comment: "Search..."))", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)
        self.searchBar.delegate = self
        self.searchBar.tintColor = .white
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.pulltoRefresh.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.pulltoRefresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(pulltoRefresh)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.Segue(notification:)), name: NSNotification.Name(rawValue: "performSegue"), object: nil)
        Reach().monitorReachabilityChanges()
        self.activityIndicator.startAnimating()
        self.tableView.register(UINib(nibName: "PostLiveCell", bundle: nil), forCellReuseIdentifier: "LiveCell")
        self.tableView.register(UINib(nibName: "SuggestedGroupTableCell", bundle: nil), forCellReuseIdentifier: "suggestedTableCell")
        self.tableView.register(UINib(nibName: "SuggestedUserTableCell", bundle: nil), forCellReuseIdentifier: "suggestedUserTableCell")
        SetUpcells.setupCells(tableView: self.tableView)
        self.tableView.register(UINib(nibName: "SortFilterCell", bundle: nil), forCellReuseIdentifier: "SortCell")
        if (AppInstance.instance.newsFeed_data.count == 0){
            self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "0")
        }
        else{
            self.activityIndicator.stopAnimating()
            self.newsFeedArray = AppInstance.instance.newsFeed_data
            self.off_set = self.newsFeedArray.last?["post_id"] as? String ?? "0"
            self.tableView.reloadData()
        }
        
        if (AppInstance.instance.suggested_groups.count == 0) {
            self.getSuggestedGroup(type: "groups", limit: 8)
        }
        else {
            self.activityIndicator.stopAnimating()
            self.suggestedGroupArray = AppInstance.instance.suggested_groups
            self.tableView.reloadData()
        }
        
        if(AppInstance.instance.suggested_users.count == 0) {
            self.getSuggestedUser(type: "users", limit: 8)
            self.tableView.reloadData()
        }
        else {
            self.activityIndicator.stopAnimating()
            self.suggestedUserArray = AppInstance.instance.suggested_users
            self.tableView.reloadData()
        }
        
        if ControlSettings.shouldShowAddMobBanner{
            //            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
            //            let request = GADRequest()
            //            interstitial.load(request)
            GADInterstitialAd.load()
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        //        print(UserData.getAccess_Token())
        //        print(UserData.getUSER_ID())
        
        //        self.getnewpost()
        //        let everyMinuteTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel() {
        var newTempArray = [[String:Any]]()
        GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: self.filter, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit: 1, off_set: "0") {[weak self] (success, authError, error) in
            if success != nil {
                for i in success!.data{
                    newTempArray.append(i)
                }
                //                print(newTempArray[0]["post_id"] as! String)
                //                print(self!.newsFeedArray[0]["post_id"] as! String)
                //
                if self!.newsFeedArray[0]["post_id"] as! String == newTempArray[0]["post_id"] as! String {
                }
                else {
                    self!.flagTemp = false
                }
            }
        }
        
        if self.flagTemp != true {
            self.gotoTop.isHidden = false
        }
    }
    
    func getnewpost() {
        DispatchQueue.global().async {
            var newTempArray = [[String:Any]]()
            while self.flagTemp {
                //                if self.flagTemp == true {
                newTempArray.removeAll()
                GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: self.filter, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit: 1, off_set: "0") {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            newTempArray.append(i)
                        }
                    }
                }
                
                if newTempArray.count >= 1 {
                    print(self.newsFeedArray[0]["post_id"] as! String)
                    print(newTempArray[0]["post_id"] as! String)
                    if self.newsFeedArray[0]["post_id"] as! String == newTempArray[0]["post_id"] as! String {
                        //                        self.gotoTop.isHidden = true
                    }
                    else {
                        //                        self.gotoTop.isHidden = false
                        self.flagTemp = false
                    }
                }
            }
            self.gotoTop.isHidden = false
        }
    }
    
    func CreateAd() -> GADInterstitialAd {
        let interstitial = GADInterstitialAd()
        //            interstitial.load(GADRequest())
        return interstitial
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        //        self.navigationController?.navigationItem.rightBarButtonItem.i
        self.tableView.reloadData()
        self.tabBarController?.delegate = self
        AppInstance.instance.vc = "newsFeedVC"
        NotificationCenter.default.addObserver(self, selector: #selector(self.Segue(notification:)), name: NSNotification.Name(rawValue: "performSegue"), object: nil)
        if AppInstance.instance.commingBackFromAddPost{
            newsFeedArray.removeLast()
            self.storiesArray.removeAll()
            self.tableView.reloadData()
            self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "0")
            self.tableView.reloadData()
            AppInstance.instance.commingBackFromAddPost = false
        }
        else{
            
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        self.
        self.flag = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "performSegue"), object: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        print(tabBarIndex)
        
        if tabBarIndex == 0 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @IBAction func addStoriesPressed(_ sender: Any) {
        //        self.showStoriesLog()
        self.showLogs()
        //        self.popUpStream()
    }
    
    @IBAction func gotoTopAction(_ sender: Any) {
        self.newsFeedArray.removeAll()
        self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "0")
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        self.gotoTop.isHidden = true
        self.flagTemp = true
        self.flag = false
        self.tableView.reloadData()
        //        self.getnewpost()
    }
    
    func popUpStream() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(identifier: "CreateLiveVC") as! CreateLiveController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func showLogs(){
        let alert = UIAlertController(title: "", message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create Live Video", comment: "Create Live Video"), style: .default, handler: { (_) in
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(identifier: "CreateLiveVC") as! CreateLiveController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }))
        
        
        /////
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create Event", comment: "Create Event"), style: .default, handler: { (_) in
            let Storyboards = UIStoryboard(name: "MarketPlaces-PopularPost-Events", bundle: nil)
            let vc = Storyboards.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventController
            vc.isHome = 1
            vc.delgate = self
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create New Product", comment: "Create New Product"), style: .default, handler: { (_) in
            let Storyboard = UIStoryboard(name: "MarketPlaces-PopularPost-Events", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "CreateProductVC") as! CreateProductController
            vc.isHome = 1
            vc.delgate1 = self
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create New Page", comment: "Create New Page"), style: .default, handler: { (_) in
            
            let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePageVC") as! CreatePageController
            vc.isHome = 1
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            //            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
            //            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SortFilterCell
            //            cell.followLbl.text = NSLocalizedString("People i Follow", comment: "People i Follow")
            //            self.filter = 0
            //            self.off_set = ""
            //            self.activityIndicator.startAnimating()
            //            self.newsFeedArray.removeAll()
            //            self.tableView.reloadData()
            //            self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:10, offset: "0")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create New Group", comment: "Create New Group"), style: .default, handler: { (_) in
            let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupController
            vc.isHome = 1
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            //            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
            //            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SortFilterCell
            //            cell.followLbl.text = NSLocalizedString("People i Follow", comment: "People i Follow")
            //            self.filter = 0
            //            self.off_set = ""
            //            self.activityIndicator.startAnimating()
            //            self.newsFeedArray.removeAll()
            //            self.tableView.reloadData()
            //            self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:10, offset: "0")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func showStoriesLog(){
        let alert = UIAlertController(title: NSLocalizedString("source", comment: "source"), message: NSLocalizedString("Add new Story", comment: "Add new Story"), preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                self.isVideo = false
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else{
                let alert  = UIAlertController(title: NSLocalizedString("Warning", comment: "Warning"), message: NSLocalizedString("You don't have camera", comment: "You don't have camera"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        let videos = UIAlertAction(title: NSLocalizedString("Videos", comment: "Videos"), style: .default) { (UIAlertAction) in
            self.isVideo = true
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = ["public.movie"]
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let image = UIAlertAction(title: NSLocalizedString("image", comment: "image"), style: .default) { (action) in
            self.isVideo = false
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.mediaTypes = ["public.image"]
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (action) in
            print("cancel")
        }
        alert.addAction(image)
        alert.addAction(videos)
        alert.addAction(camera)
        alert.addAction(cancel)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
        
    }
    
    func loadEvent(type: String) {
        self.activityIndicator.startAnimating()
        self.newsFeedArray.removeAll()
        self.view.isUserInteractionEnabled = false
        self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "")
    }
    
    
    func editPost(newtext: String, postPrivacy: String) {
        self.newsFeedArray[self.selectedIndex]["postText"] = newtext
        self.newsFeedArray[self.selectedIndex]["postPrivacy"] = postPrivacy
        self.tableView.reloadData()
    }
    
    
    @objc func Segue(notification: NSNotification){
        if let type = notification.userInfo?["type"] as? String{
            if type == "profile"{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                var groupId: String? = nil
                var pageId: String? = nil
                var user_data: [String:Any]? = nil
                if let data = notification.userInfo?["userData"] as? Int{
                    print(data)
                    if let groupid = self.newsFeedArray[data]["group_id"] as? String{
                        groupId = groupid
                    }
                    if let page_Id = self.newsFeedArray[data]["page_id"] as? String{
                        pageId = page_Id
                    }
                    if let userData = self.newsFeedArray[data]["publisher"] as? [String:Any]{
                        user_data = userData
                    }
                }
                if pageId != "0"{
                    let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PageVC") as! PageController
                    
                    vc.page_id = pageId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if groupId != "0"{
                    let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
                    vc.id = groupId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    if let id = user_data?["user_id"] as? String{
                        if id == UserData.getUSER_ID(){
                            let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            vc.userData = user_data
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            
            else if (type == "share"){
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                var groupId: String? = nil
                var pageId: String? = nil
                var user_data: [String:Any]? = nil
                if let data = notification.userInfo?["userData"] as? Int{
                    if let shared_info = self.newsFeedArray[data]["shared_info"] as? [String:Any]{
                        if shared_info != nil{
                            if let groupid = self.newsFeedArray[data]["group_id"] as? String{
                                groupId = groupid
                            }
                            if let page_Id = self.newsFeedArray[data]["page_id"] as? String{
                                pageId = page_Id
                            }
                            if let publisher = shared_info["publisher"] as? [String:Any]{
                                user_data = publisher
                            }
                            if pageId != "0"{
                                let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "PageVC") as! PageController
                                
                                vc.page_id = pageId
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else if groupId != "0"{
                                let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
                                vc.id = groupId
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                if let id = user_data?["user_id"] as? String{
                                    if id == UserData.getUSER_ID(){
                                        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else{
                                        vc.userData = user_data
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        }
                        else{
                            if let tag = notification.userInfo?["tag"] as? Int{
                                if let groupid = self.newsFeedArray[tag]["group_id"] as? String{
                                    groupId = groupid
                                }
                                if let page_Id = self.newsFeedArray[tag]["page_id"] as? String{
                                    pageId = page_Id
                                }
                                if let userData = self.newsFeedArray[tag]["publisher"] as? [String:Any]{
                                    user_data = userData
                                }
                            }
                            if pageId != "0"{
                                let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "PageVC") as! PageController
                                
                                vc.page_id = pageId
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else if groupId != "0"{
                                let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
                                vc.id = groupId
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                if let id = user_data?["user_id"] as? String{
                                    if id == UserData.getUSER_ID(){
                                        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else{
                                        vc.userData = user_data
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if type == "product"{
                let Storyboard = UIStoryboard(name: "MarketPlaces-PopularPost-Events", bundle: nil)
                let vc = Storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailController
                if let data = notification.userInfo?["userData"] as? Int{
                    let index =  self.newsFeedArray[data]
                    var seller = [String:Any]()
                    if let publisher = index["publisher"] as? [String:Any]{
                        seller = publisher
                    }
                    if var product = index["product"] as? [String:Any]{
                        product.updateValue(seller, forKey: "seller")
                        vc.productDetails = product
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "edit"{
                let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
                if let index = notification.userInfo?["userData"] as? Int{
                    self.selectedIndex = index
                    print(index)
                }
                if let postId = notification.userInfo?["postId"] as? String{
                    vc.post_id = postId
                }
                if let texts = notification.userInfo?["text"] as? String{
                    if texts != ""{
                        vc.postText = texts
                    }
                }
                if let priva = notification.userInfo?["privacy"] as? String{
                    vc.postPrivacy = Int(priva)
                }
                vc.delegate = self
                vc.isFrom_Edit = "1"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if type == "delete"{
                if let data = notification.userInfo?["userData"] as? Int{
                    print(data)
                    self.newsFeedArray.remove(at: data)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @objc func loadList(notification: NSNotification){
        var post_id = ""
        if let data = notification.userInfo?["data"] as? [String:Any] {
            if let id = data["post_id"] as? String{
                post_id = id
            }
            switch status {
            case .unknown, .offline:
                ZKProgressHUD.dismiss()
                self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            case .online(.wwan), .online(.wiFi):
                performUIUpdatesOnMain {
                    GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: self.filter, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit: 10, off_set: "") {[weak self] (success, authError, error) in
                        if success != nil {
                            for i in success!.data{
                                if i["post_id"] as? String == post_id{
                                    self?.newsFeedArray.insert(i, at: 0)
                                }
                            }
                            self?.audioPlayer.play()
                            self?.spinner.stopAnimating()
                            self?.pulltoRefresh.endRefreshing()
                            self?.tableView.reloadData()
                            ZKProgressHUD.dismiss()
                        }
                        else if authError != nil {
                            ZKProgressHUD.dismiss()
                            self?.view.makeToast(authError?.errors.errorText)
                            self?.showAlert(title: "", message: (authError?.errors.errorText)!)
                        }
                        else if error  != nil {
                            ZKProgressHUD.dismiss()
                            print(error?.localizedDescription)
                            
                        }
                    }
                }
            }
        }
    }
    func loadStories(){
        
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                StoriesManager.sharedInstance.getUserStories(offset: 0, limit: 10) {[weak self] (success, authError, error) in
                    if success != nil {
                        self!.storiesArray = success?.stories ?? []
                        self?.tableView.reloadData()
                        
                    }
                    else if authError != nil {
                        ZKProgressHUD.dismiss()
                        self!.view.makeToast(authError?.errors?.errorText)
                        self!.showAlert(title: "", message: (authError?.errors?.errorText)!)
                    }
                    else if error  != nil {
                        ZKProgressHUD.dismiss()
                        print(error?.localizedDescription)
                        
                    }
                } 
            }
        }
    }
    
    
    
    //Pull To Refresh
    
    @objc func refresh(){
        self.off_set = ""
        self.newsFeedArray.removeAll()
        self.tableView.reloadData()
        self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "0")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    private func getSuggestedUser(type: String, limit: Int) {
        GetSuggestedGroupManager.sharedInstance.getGroups(type: type, limit: 8) {
            (success, authError, error) in
            if success != nil {
                for i in success!.data {
                    self.suggestedUserArray.append(i)
                }
                print("----------------")
                print("suggested users")
                print(self.suggestedUserArray.count)
                print("----------------")
                self.tableView.reloadData()
            }
            else if authError != nil {
                self.view.isUserInteractionEnabled = true
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if error  != nil {
                self.view.isUserInteractionEnabled = true
                print(error?.localizedDescription)
            }
        }
    }
    
    private func getSuggestedGroup(type: String, limit: Int) {
        GetSuggestedGroupManager.sharedInstance.getGroups(type: type, limit: 8) {
            (success, authError, error) in
            if success != nil {
                for i in success!.data {
                    self.suggestedGroupArray.append(i)
                }
                self.tableView.reloadData()
            }
            else if authError != nil {
                self.view.isUserInteractionEnabled = true
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if error  != nil {
                self.view.isUserInteractionEnabled = true
                print(error?.localizedDescription)
            }
        }
    }
    
    private func getNewsFeed (access_token : String, limit : Int, offset : String) {
        
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            self.view.isUserInteractionEnabled = true
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: self.filter, access_token: access_token, limit: limit, off_set: offset) {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            self?.newsFeedArray.append(i)
                        }
                        self?.off_set = self?.newsFeedArray.last?["post_id"] as? String ?? "0"
                        for it in self!.newsFeedArray{
                            let boosted = it["is_post_boosted"] as? Int ?? 0
                            self?.newsFeedArray.sorted(by: { _,_ in boosted == 1 })
                        }
                        //                        let boosted = self?.newsFeedArray["is_post_boosted"] as? Int ?? 0
                        //                        self?.newsFeedArray.sorted(by: { _,_ in boosted == 1 })
                        self?.spinner.stopAnimating()
                        self?.pulltoRefresh.endRefreshing()
                        self?.tableView.reloadData()
                        self?.view.isUserInteractionEnabled = true
                        self?.loadStories()
                        self?.activityIndicator.stopAnimating()
                        ZKProgressHUD.dismiss()                        
                    }
                    else if authError != nil {
                        ZKProgressHUD.dismiss()
                        self?.view.isUserInteractionEnabled = true
                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error  != nil {
                        ZKProgressHUD.dismiss()
                        self?.view.isUserInteractionEnabled = true
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc func seeAllGroups() {
        let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GroupsDiscoverVC") as! GroupsDiscoverController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func seeAllUsers() {
        var tempData = [[String: Any]]()
        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FindFriendVC") as! FindFriendVC
        GetSuggestedGroupManager.sharedInstance.getGroups(type: "users", limit: 20) {
            (success, authError, error) in
            if success != nil {
                for i in success!.data {
                    tempData.append(i)
                }
            }
            else if authError != nil {
                self.view.isUserInteractionEnabled = true
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if error  != nil {
                self.view.isUserInteractionEnabled = true
            }
        }
        vc.titleName = "Suggestion Users"
        vc.nearByFriends = tempData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func GotoCamera(sender: UIButton){
        let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
        vc.isopenCamera = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func GotoAddPost(sender: UIButton){
        let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
        vc.isOpenSheet = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createLive(name: String) {
        let Storyboards = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboards.instantiateViewController(withIdentifier: "LiveVC") as! LiveStreamController
        vc.streamName = name
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StroiesCell") as! StoriesCell
            self.tableView.rowHeight = 100
            cell.bind(self.storiesArray)
            cell.vc = self
            return cell
            
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostStatusCell") as! PostStatusCell
            cell.bind()
            self.tableView.rowHeight = 80.0
            cell.moreBtn.addTarget(self, action: #selector(self.GotoAddPost(sender:)), for: .touchUpInside)
            cell.photoBtn.addTarget(self, action: #selector(self.GotoCamera(sender:)), for: .touchUpInside)
            return cell
        }
        if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortFilterCell
            self.tableView.rowHeight = 45
            return cell
        }
        if (indexPath.section == 3){
            if flag {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherCell") as! OtherCell
                
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                
                if hour < 8 && hour > 0 {
                    cell.moringLabel.text = "Good Morning, " + (UserData.getUSER_NAME() ?? "")
                    cell.morningDetailsLabel.text = "May this morning be light, blessed, enlightened, productive and happy"
                    cell.morningImage.image = UIImage(named: "ic_post_park")
                }
                else if hour < 17 {
                    cell.moringLabel.text = "Good Afternoon, " + (UserData.getUSER_NAME() ?? "")
                    cell.morningDetailsLabel.text = "May this afternoon be light, blessed, enlightened, productive and happy"
                    cell.morningImage.image = UIImage(named: "ic_post_sea")
                }
                else {
                    cell.moringLabel.text = "Good Evening, " + (UserData.getUSER_NAME() ?? "")
                    cell.morningDetailsLabel.text = "Evenings are life's way of saying that you are closer to your dreams"
                    cell.morningImage.image = UIImage(named: "ic_post_desert")
                }
                self.tableView.rowHeight = 97
                return cell
            }
            
            else {
                let cell = UITableViewCell()
                self.tableView.rowHeight = 0
                return cell
            }
        }
        if (indexPath.section == 4) {
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        if (indexPath.section == 5) {
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else  {
            if (indexPath.row == 20){
                let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedUserTableCell") as! SuggestedUserTableCell
                cell.suggestedUsers = self.suggestedUserArray
                cell.seeAllBtn.addTarget(self, action: #selector(seeAllUsers), for: .touchUpInside)
                cell.userDelegate = self
                self.tableView.rowHeight = 287
                return cell
            }
            if (indexPath.row == 40){
                let cell = tableView.dequeueReusableCell(withIdentifier: "suggestedTableCell") as! SuggestedGroupTableCell
                cell.suggestedGroups = self.suggestedGroupArray
                cell.seeAllBtn.addTarget(self, action: #selector(seeAllGroups), for: .touchUpInside)
                cell.groupDelegate = self
                self.tableView.rowHeight = 287
                return cell
            }
            let index = self.newsFeedArray[indexPath.row]
            var tableViewCells = UITableViewCell()
            var shared_info : [String:Any]? = nil
            var fundDonation: [String:Any]? = nil
            var live = ""
            let postfile = index["postFile"] as? String ?? ""
            let postLink = index["postLink"] as? String ?? ""
            let postYoutube = index["postYoutube"] as? String ?? ""
            let blog = index["blog_id"] as? String ?? "0"
            let group = index["group_recipient_exists"] as? Bool ??  false
            let product = index["product_id"] as? String ?? "0"
            let event = index["page_event_id"] as? String ?? "0"
            let postSticker = index["postSticker"] as? String ?? ""
            let colorId = index["color_id"] as? String ?? "0"
            let multi_image = index["multi_image"] as? String ?? "0"
            let photoAlbum = index["album_name"] as? String ?? ""
            let postOptions = index["poll_id"] as? String ?? "0"
            let postRecord = index["postRecord"] as? String ?? "0"
            if let postType = index["postType"] as? String{
                live = postType
            }
            if let sharedInfo = index["shared_info"] as? [String:Any] {
                shared_info = sharedInfo
            }
            if let fund = index["fund_data"] as? [String:Any]{
                fundDonation = fund
            }
            
            if (shared_info != nil){
                tableViewCells = GetPostShare.sharedInstance.getsharePost(targetController: self, tableView: self.tableView, indexpath: indexPath, postFile: postfile, array: self.newsFeedArray)
            }
            else if (live == "live"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell") as! PostLiveCell
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 350.0
                cell.bind(index: index, indexPath: indexPath.row)
                cell.vc = self
                tableViewCells = cell
            }
            else if (postfile != "")  {
                let url = URL(string: postfile)
                let urlExtension: String? = url?.pathExtension
                if (urlExtension == "jpg" || urlExtension == "png" || urlExtension == "jpeg" || urlExtension == "JPG" || urlExtension == "PNG"){
                    print("NewsFeed",indexPath.row)
                    tableViewCells = GetPostWithImage.sharedInstance.getPostImage(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.newsFeedArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                
                else if(urlExtension == "wav" ||  urlExtension == "mp3" || urlExtension == "MP3"){
                    tableViewCells = GetPostMp3.sharedInstance.getMP3(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.newsFeedArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                else if (urlExtension == "pdf") {
                    tableViewCells = GetPostPDF.sharedInstance.getPostPDF(targetControler: self, tableView: self.tableView, indexpath: indexPath, postfile: postfile, array: self.newsFeedArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                    
                }
                
                else {
                    tableViewCells = GetPostVideo.sharedInstance.getVideo(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.newsFeedArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
            }
            
            else if (postLink != "") {
                tableViewCells = GetPostWithLink.sharedInstance.getPostLink(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postLink, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if (postYoutube != "") {
                tableViewCells = GetPostYoutube.sharedInstance.getPostYoutub(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postYoutube, array: self.newsFeedArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (blog != "0") {
                tableViewCells = GetPostBlog.sharedInstance.GetBlog(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if (group != false){
                tableViewCells = GetPostGroup.sharedInstance.GetGroupRecipient(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if (product != "0") {
                tableViewCells = GetPostProduct.sharedInstance.GetProduct(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else if (event != "0") {
                tableViewCells = GetPostEvent.sharedInstance.getEvent(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array:  self.newsFeedArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (postSticker != "") {
                tableViewCells = GetPostSticker.sharedInstance.getPostSticker(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if (colorId != "0"){
                tableViewCells = GetPostWithBg_Image.sharedInstance.postWithBg_Image(targetController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if (multi_image != "0") {
                tableViewCells = GetPostMultiImage.sharedInstance.getMultiImage(targetController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            
            else if photoAlbum != "" {
                tableViewCells = getPhotoAlbum.sharedInstance.getPhoto_Album(targetController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if postOptions != "0" {
                tableViewCells = GetPostOptions.sharedInstance.getPostOptions(targertController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            
            else if postRecord != ""{
                tableViewCells = GetPostRecord.sharedInstance.getPostRecord(targetController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if fundDonation != nil{
                tableViewCells = GetDonationPost.sharedInstance.getDonationpost(targetController: self, tableView: tableView, indexpath: indexPath, array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            
            else {
                tableViewCells = GetNormalPost.sharedInstance.getPostText(targetController: self, tableView: self.tableView, indexpath: indexPath, postFile: "", array: self.newsFeedArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            return tableViewCells
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.newsFeedArray.count >= 15 {
            let count = self.newsFeedArray.count
            let lastElement = count - 1
            
            if indexPath.row == lastElement {
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                
                self.tableView.tableFooterView?.isHidden = false
                self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit: 15, offset: off_set)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        GetPostMp3.sharedInstance.timer1.invalidate()
        GetPostRecord.sharedInstance.timer1.invalidate()
        GetPostMp3.sharedInstance.stopSound()
        GetPostRecord.sharedInstance.stopSound()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if (section == 1) {
            return 1
        }
        else if (section == 2) {
            return 1
        }
        else if (section == 3) {
            return 1
        }
        else if (section == 4) {
            return 1
        }
        else if (section == 5) {
            return 1
        }
        else {
            return self.newsFeedArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.instance.addCount == ControlSettings.interestialCount {
            //            if interstitial.isReady {
            //                interstitial.present(fromRootViewController: self)
            //                interstitial = CreateAd()
            //                AppInstance.instance.addCount = 0
            //            } else {
            //
            //                print("Ad wasn't ready")
            //            }
            interstitial.present(fromRootViewController: self)
            interstitial = CreateAd()
            AppInstance.instance.addCount = 0
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        if indexPath.section == 0 {
            print("Nothing")
            
        }
        else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.section == 2{
            
            let alert = UIAlertController(title: "", message: NSLocalizedString("Filter", comment: "Filter"), preferredStyle: .actionSheet)
            
            alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: NSLocalizedString("All", comment: "All"), style: .default, handler: { (_) in
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SortFilterCell
                cell.followLbl.text = NSLocalizedString("All", comment: "All")
                self.filter = 1
                self.off_set = ""
                self.activityIndicator.startAnimating()
                self.newsFeedArray.removeAll()
                self.tableView.reloadData()
                self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:15, offset: "0")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("People i Follow", comment: "People i Follow"), style: .default, handler: { (_) in
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SortFilterCell
                cell.followLbl.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                self.filter = 0
                self.off_set = ""
                self.activityIndicator.startAnimating()
                self.newsFeedArray.removeAll()
                self.tableView.reloadData()
                self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:10, offset: "0")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
                print("User click Dismiss button")
            }))
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
        else if indexPath.section == 3 {
            self.flag = false
            self.tableView.reloadData()
        }
        else {
            print("Didtap")
        }
    }
}
extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if self.isVideo! {
                
                let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                var CreateVideoStoryVC = UIStoryboard(name: "Stories", bundle: nil).instantiateViewController(withIdentifier: "CreateVideoStoryVC") as! CreateVideoStoryVC
                let videoData = try? Data(contentsOf: vidURL)
                CreateVideoStoryVC.videoData1 = videoData
                CreateVideoStoryVC.videoLinkString  = vidURL.absoluteString
                self.navigationController?.pushViewController(CreateVideoStoryVC, animated: true)
                
            }else{
                let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                var CreateImageStoryVC = UIStoryboard(name: "Stories", bundle: nil).instantiateViewController(withIdentifier: "CreateImageStoryVC") as! CreateImageStoryVC
                CreateImageStoryVC.imageLInkString  = FileManager().savePostImage(image: img!)
                CreateImageStoryVC.iamge = img
                CreateImageStoryVC.isVideo = self.isVideo
                self.navigationController?.pushViewController(CreateImageStoryVC, animated: true)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ViewController: UserDelegate {
    func didSelectItem(record: [String: Any]) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
        vc.userData = record
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: GroupDelegate {
    func didSelectItem1(record: [String: Any]) {
        let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
        let index = record
        if let groupId = index["group_id"] as? String{
            vc.groupId = groupId
        }
        if let groupName = index["group_name"] as? String{
            vc.groupName = groupName
        }
        if let groupTitle = index["group_title"] as? String{
            vc.groupTitle = groupTitle
        }
        if let groupIcon = index["avatar"] as? String{
            vc.groupIcon = groupIcon
        }
        if let groupCover = index["cover"] as? String{
            vc.groupCover = groupCover
        }
        if let groupcategory = index["category"] as? String{
            vc.category = groupcategory
        }
        if let privacy = index["privacy"] as? String{
            vc.privacy = privacy
        }
        if let categoryId = index["category_id"] as? String{
            print(categoryId)
            vc.categoryId = categoryId
        }
        
        if let about  = index["about"] as? String{
            print(about)
            vc.aboutGroup = about
        }
        if let isJoined = index["is_joined"] as? Bool{
            vc.isJoined = isJoined
        }
        vc.groupData = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
