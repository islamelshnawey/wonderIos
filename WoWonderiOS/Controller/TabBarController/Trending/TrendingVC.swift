//
//  TrendingVC.swift
//  News_Feed
//
//  Created by Muhammad Haris Butt on 3/25/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import AlamofireImage
import Kingfisher
import SDWebImage
import PaginatedTableView
import Toast_Swift
import ZKProgressHUD
import WoWonderTimelineSDK
import GoogleMobileAds




class TrendingVC: UIViewController,UITabBarControllerDelegate,loadEventDelegate,createLiveDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let spinner = UIActivityIndicatorView(style: .gray)
    let pulltoRefresh = UIRefreshControl()
    var proUsers = [ProUserModel.ProUser]()
    var lastActivitiesArray = [[String:Any]]()
    var friendRequests = [[String:Any]]()
    let status = Reach().connectionStatus()
    var interstitial: GADInterstitialAd!
    
    var trending_hashtag = [[String:Any]]()

    
    var isVideo:Bool? = false
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 40))
    let placeholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.white])
    
    let rightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: AppInstance.instance.appColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
//            UIColor.hexStringToUIColor(hex: "994141")
         self.navigationController?.navigationItem.largeTitleDisplayMode = .never
       
        self.setupUI()
        self.tabBarController?.delegate = self
        if ControlSettings.shouldShowAddMobBanner{
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
            GADInterstitialAd.load()
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.tableView.register(UINib(nibName: "TrendingCell", bundle: nil), forCellReuseIdentifier: "trendingCell")
     
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title  = NSLocalizedString("Activities", comment: "Activities")
            self.getRequest()
            self.rightButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.rightButton.isHidden = true
    }
 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let tabBarIndex = tabBarController.selectedIndex

        print(tabBarIndex)

        if tabBarIndex == 2 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @IBAction func cameraPresserd(_ sender: Any) {
        self.showStoriesLog()

    }
    func CreateAd() -> GADInterstitialAd {
            let interstitial = GADInterstitialAd()
//            interstitial.load(GADRequest())
            return interstitial
        }
    
    
    @objc func AddAction(sender:UIBarButtonItem){
        self.showLogs()
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
    private func setupUI(){
        
       
         rightButton.setImage(UIImage(named: "add-button"), for: .normal)
         rightButton.addTarget(self, action: #selector(self.AddAction(sender:)), for: .touchUpInside)
         navigationController?.navigationBar.addSubview(rightButton)
         rightButton.tag = 1
         rightButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 20)

         let targetView = self.navigationController?.navigationBar

         let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
             .trailingMargin, relatedBy: .equal, toItem: targetView,
                              attribute: .trailingMargin, multiplier: 1.0, constant: -16)
         let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                         toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -13)
         rightButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
        
        self.tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "ActivitiesSectionOneTableitem", bundle: nil), forCellReuseIdentifier: "ActivitiesSectionOneTableitem")
        
        let nibName = UINib(nibName: "ActivitiesThreeTableItem", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "ActivitiesThreeTableItem")
//        tableView.register(UINib(nibName: "ActivitiesThreeTableItem", bundle: nil), forCellReuseIdentifier: "ActivitiesThreeTableItem")
        
        tableView.register(UINib(nibName: "ActivitiesSectionTwoTableItem", bundle: nil), forCellReuseIdentifier: "ActivitiesSectionTwoTableItem")
        self.tableView.register(UINib(nibName: "FriendRequestCell", bundle: nil), forCellReuseIdentifier: "FriendRequestcell")
        print(UserData.getUSER_ID()!)
        print(UserData.getAccess_Token()!)
//        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
//            textfield.clearButtonMode = .never
//            textfield.backgroundColor = UIColor.clear
//            textfield.attributedPlaceholder = NSAttributedString(string:" Search...", attributes:[NSAttributedString.Key.foregroundColor: UIColor.yellow])
//            textfield.textColor = .white
//            if let leftView = textfield.leftView as? UIImageView {
//                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
//                leftView.tintColor = UIColor.white
//            }
//        }
//        self.searchBar.delegate = self
//        self.searchBar.tintColor = .white
//        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.pulltoRefresh.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
//            UIColor.hexStringToUIColor(hex: "#984243")
        self.pulltoRefresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(pulltoRefresh)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        //
        Reach().monitorReachabilityChanges()
//        ZKProgressHUD.show("Loading")
        self.activityIndicator.startAnimating()
        SetUpcells.setupCells(tableView: self.tableView)
        self.loadProUsers()
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
        
    }
    @objc func refresh(){
        self.proUsers.removeAll()
        self.tableView.reloadData()
        loadProUsers()
        pulltoRefresh.endRefreshing()
        
    }
    
    
    
    private func getRequest(){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            
            GetFriendRequestManager.sharedInstance.getFriendRequest { (success, authError, error) in
                
                if success != nil{
                    for i in success!.friend_requests{
                        self.friendRequests.append(i)
                    }
                    self.tableView.reloadData()
                }
                else if (authError != nil){
                    self.view.makeToast(authError?.errors.errorText)
                }
                else if (error != nil){
                    self.view.makeToast(error?.localizedDescription)
                }
            }
        }
        
    }
    
    
    private func loadProUsers(){
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                ProUserManager.instance.getProUsers(offset: 0, limit: 20, type: "pro_users") { (success, authError, error) in
                    print(success?.proUsers)
                    if success != nil {
                        self.proUsers = success?.proUsers ?? []
                        self.loadActivities()
                        self.getGeneralData()
                        self.tableView.reloadData()
                        print(self.proUsers)
                        self.activityIndicator.stopAnimating()
                    }
                    else if authError != nil {
                        ZKProgressHUD.dismiss()
                        self.view.makeToast(authError?.errors?.errorText)
                        self.showAlert(title: "", message: (authError?.errors?.errorText)!)
                    }
                    else if error  != nil {
                        ZKProgressHUD.dismiss()
                        print(error?.localizedDescription)
                        
                    }
                }
            }
        }
    }
    private func loadActivities(){
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                LastActivitiesManager.instance.getLastActivites(offset: 0, limit: 5) { (success, authError, error) in
                    print(success?.activities)
                    if success != nil {
                        self.lastActivitiesArray = success?.activities ?? []
                        self.tableView.reloadData()
                        ZKProgressHUD.dismiss()
                        self.pulltoRefresh.endRefreshing()
                        self.activityIndicator.stopAnimating()
                        
                    }
                    else if authError != nil {
                        ZKProgressHUD.dismiss()
                        self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if error  != nil {
                        ZKProgressHUD.dismiss()
                        print(error?.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
    func loadEvent(type: String) {
        self.activityIndicator.startAnimating()
//        self.newsFeedArray.removeAll()
//        self.view.isUserInteractionEnabled = false
//        self.getNewsFeed(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:10, offset: "")
    }
    
    func createLive(name: String) {
        let Storyboards = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboards.instantiateViewController(withIdentifier: "LiveVC") as! LiveStreamController
        vc.streamName = name
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func getGeneralData(){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetGeneralDataManager.sharedInstance.getGeneralDataManager(fetch: "trending_hashtag", offset: "") { (success, authError, Error) in
                    if success != nil {
                        for i in success!.trending_hashtag{
                            self.trending_hashtag.append(i)
                        }
                        print(self.trending_hashtag)
                        self.tableView.reloadData()
                    }
                    else if authError != nil{
                        self.view.makeToast(authError?.errors.errorText)
                    }
                    else if Error != nil{
                        self.view.makeToast(Error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
}

extension TrendingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 100.0
        case 1: return 70.0
        case 2: return 0.0
        case 3: return 60.0
        case 4: return 80.0
        default: return 0
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
        view.backgroundColor = UIColor.white
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
        separatorView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.size.width, height: 48))
        label.textColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        label.font = UIFont(name: "Arial Bold", size: 15)
        if section == 0{
            label.text = NSLocalizedString("Pro Users", comment: "Pro Users")
            
        } else if section == 2 {
            label.text = NSLocalizedString("", comment: "")
        }
        else if section == 3 {
            label.text = NSLocalizedString("Trending HashTags", comment: "Trending HashTags")
        }
        else if section == 4 {
            let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivitiesThreeTableItem" ) as! ActivitiesThreeTableItem
            headerView.vc = self
            return headerView
//            label.text = NSLocalizedString("Activities", comment: "Activities")
        }
        view.addSubview(separatorView)
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 0
        }
        else if section == 2{
            return 0
        }
        else if section == 3{
            if (self.trending_hashtag.count == 0){
                return 0
            }
            else{
                return 56
            }
            
        }
        else if section == 4{
            if (self.lastActivitiesArray.count == 0){
                return 0
            }
            else{
                return 56
            }
            
        }
        else{
        return 56
        }
    }
}

extension TrendingVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if (self.friendRequests.count > 0 ){
                return 1
                
            }
            else {
                return 0
            }
        case 2: return 0
        case 3: return self.trending_hashtag.count
        case 4: return self.lastActivitiesArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesSectionOneTableitem") as! ActivitiesSectionOneTableitem
            cell.bind(self.proUsers)
            cell.didSelectItemAction = {[weak self] indexPath in
                self?.gotoUserProfile(indexPath: indexPath)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestcell") as! FriendRequestCell
            let index = self.friendRequests[indexPath.row]
            if (self.friendRequests.count == 1){
                cell.image2.isHidden = true
                cell.image3.isHidden = true
                if let pro_url = index["avatar"] as? String{
                    let url = URL(string: pro_url)
                    cell.image1.sd_setImage(with: url, completed: nil)
                }
            }
            else if (self.friendRequests.count == 2){
                 cell.image3.isHidden = true
                if let pro_url1 = index["avatar"] as? String{
                    let url = URL(string: pro_url1)
                    cell.image1.sd_setImage(with: url, completed: nil)
                }
                if let pro_url2 = self.friendRequests[1]["avatar"] as? String{
                    let url = URL(string: pro_url2)
                    cell.image1.sd_setImage(with: url, completed: nil)
                }
            }
            else if (self.friendRequests.count == 0){
                print("Nothing")
            }
            else{
                if let pro_url1 = self.friendRequests[0]["avatar"] as? String{
                    let url = URL(string: pro_url1)
                    cell.image1.sd_setImage(with: url, completed: nil)
                }
                if let pro_url2 = self.friendRequests[1]["avatar"] as? String{
                    let url = URL(string: pro_url2)
                    cell.image3.sd_setImage(with: url, completed: nil)
                }
                if let pro_url3 = self.friendRequests[2]["avatar"] as? String{
                    let url = URL(string: pro_url3)
                    cell.image3.sd_setImage(with: url, completed: nil)
                }
                
            }
            return cell
            
        case 2:
            let cell = UITableViewCell()
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesThreeTableItem") as! ActivitiesThreeTableItem
//            cell.selectionStyle = .none
//            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell") as! TrendingCell
            let index = self.trending_hashtag[indexPath.row]
            if let tag = index["tag"] as? String{
                cell.hashLabel.text = "\("#")\(tag)"
            }
            if let totalPost = index["trend_use_num"] as? String{
                cell.totalPostsLbl.text = "\(totalPost)\(" ")\(NSLocalizedString("Post", comment: "Post"))"
            }
             return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesSectionTwoTableItem") as! ActivitiesSectionTwoTableItem
            cell.selectionStyle = .none
            let index = self.lastActivitiesArray[indexPath.row]
            if let activitor = index["activator"] as? [String:Any]{
                if let image = activitor["avatar"] as? String{
                    let url = URL(string: image)
                    cell.profileImage.kf.setImage(with: url)
                }
              
            }
            if let descrip = index["activity_text"] as? String{
                cell.titleLabel.text = descrip
            }
            if let type = index["activity_type"] as? String{
                if type == "commented_post"{
                    cell.changeIcon.image = UIImage(named: "commentss")
                }
                else if type == "following"{
//                    cell.changeIcon.image = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
                }
                else  {
                    cell.changeIcon.image = #imageLiteral(resourceName: "like-2")
                }
            }
//            let object = self.lastActivitiesArray[indexPath.row]
////            cell.bind(object)
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.instance.addCount == ControlSettings.interestialCount {
//                                      if interstitial.isReady {
//                                          interstitial.present(fromRootViewController: self)
//                                          interstitial = CreateAd()
//                                          AppInstance.instance.addCount = 0
//                                      } else {
//                                          
//                                          print("Ad wasn't ready")
//                                      }
            interstitial.present(fromRootViewController: self)
            interstitial = CreateAd()
            AppInstance.instance.addCount = 0
                                  }
                                  AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        
//        if (indexPath.section == 2){
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "LastActivityVC") as! LastActivitesController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
         if (indexPath.section == 1){
            let Storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
             let vc = Storyboard.instantiateViewController(withIdentifier: "FollowRequestVC") as! FollowRequestController
             vc.friend_Requests = self.friendRequests
             vc.delegate = self
             self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if (indexPath.section == 3){
            let index = self.trending_hashtag[indexPath.row]
            let Storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "PostHashTagVC") as! PostHashTagController
            if let tag = index["tag"] as? String{
                vc.hashtag = tag
            }
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.section == 4{
            let index = self.lastActivitiesArray[indexPath.row]
            if let Type = index["activity_type"] as? String{
                if (Type == "following" || Type == "friend"){
                    if let activator = index["activator"] as? [String:Any]{
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                        vc.userData = activator
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else{
                    var post_id: String? = nil
                    var post_data: [String:Any]? = nil
                    if let id = index["post_id"] as? String{
                        post_id = id
                }
                    if let postData = index["postData"] as? [String:Any]{
                        post_data = postData
                    }
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ShowPostVC") as! ShowPostController
                    vc.postId = post_id
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
        }
    }
    
    func gotoUserProfile(indexPath:IndexPath){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
        let index = self.proUsers[indexPath.row]
        vc.userData = ["user_id":index.userID,"name":index.name,"avatar":index.avatar,"cover":index.cover,"points":index.points,"verified":index.verified,"is_pro":index.isPro]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension TrendingVC:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}
extension TrendingVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if self.isVideo! {
                
                let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                var CreateVideoStoryVC = UIStoryboard(name: "Stories", bundle: nil).instantiateViewController(withIdentifier: "CreateVideoStoryVC") as! CreateVideoStoryVC
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
extension TrendingVC: FollowRequestDelegate{
  func follow_request(index: Int) {
      self.friendRequests.remove(at: index)
      self.tableView.reloadData()
  }
  
}

