//
//  TrendingVC_UI.swift
//  WoWonderiOS
//
//  Created by Muhammad's Macbook pro on 11/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
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

class TrendingVC_UI: UIViewController, UITabBarControllerDelegate, createLiveDelegate, loadEventDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var blogs:[TrendingModel.Blog]?
    let pulltoRefresh = UIRefreshControl()
    var proUsers = [ProUserModel.ProUser]()
    var lastActivitiesArray = [[String:Any]]()
    var friendRequests = [[String:Any]]()
    let status = Reach().connectionStatus()
    var interstitial: GADInterstitialAd!
    var trending_hashtag = [[String:Any]]()
    var isVideo:Bool? = false
    let rightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white//UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
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
        self.tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(UINib(nibName: "TrendingHeaderCells", bundle: nil), forCellReuseIdentifier: "TrendingHeaderCells")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")

        // Do any additional setup after loading the view.
    }
    
    @objc func AddAction(sender:UIBarButtonItem){
        self.showLogs()
    }
    
    @IBAction func messengerClicked(_ sender: Any) {
        let appURLScheme = "AppToOpen://"
        guard let appURL = URL(string: appURLScheme) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(appURL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
        else {
            self.view.makeToast("Please install Chats App")
        }
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
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
        self.tableView.register(UINib(nibName: "WeatherCell_UI", bundle: nil), forCellReuseIdentifier: "WeatherCell_UI")
        self.tableView.register(UINib(nibName: "TrendingBlogsCells", bundle: nil), forCellReuseIdentifier: "TrendingBlogsCells")
        print(UserData.getUSER_ID()!)
        print(UserData.getAccess_Token()!)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title  = NSLocalizedString("Activities", comment: "Activities")
        self.getRequest()
        self.rightButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.rightButton.isHidden = true
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        self.openMessenger()
    }
    
    func openMessenger(){
        let appURLScheme = "AppToOpen://"
        guard let appURL = URL(string: appURLScheme) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(appURL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
        else {
            self.view.makeToast("Please install Chats App")
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        print(tabBarIndex)
        
        if tabBarIndex == 2 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
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
                        self.fetchLatestBlog()
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
    
    func fetchLatestBlog(){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetGeneralDataManager.sharedInstance.getLatestBlogs() { (success, authError, Error) in
                    if success != nil {
                        self.blogs = success?.blogs
                        self.tableView.reloadData()
                    }
                    else if authError != nil{
                        self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if Error != nil{
                        self.view.makeToast(Error?.localizedDescription)
                    }
                }
            }
        }
    }
    
}

extension TrendingVC_UI: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.proUsers.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            if indexPath.row == 0 {
                return 50
            }else {
                return 80
            }
        }else if indexPath.section == 1 {
            if self.trending_hashtag.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            if indexPath.row == 0 {
                return 50
            }else {
                return 65
            }
        }
//        else if indexPath.section == 2 {
//            if self.lastActivitiesArray.isEmpty {
//                return CGFloat.leastNonzeroMagnitude
//            }
//            if indexPath.row == 0 {
//                return 50
//            }else {
//                return 75
//            }
//        }else if indexPath.section == 3{
//            if self.proUsers.isEmpty {
//                return CGFloat.leastNonzeroMagnitude
//            }
//            return 550
//        }
        else if indexPath.section == 2{
            guard let _ = self.blogs else { return CGFloat.leastNonzeroMagnitude}
            if indexPath.row == 0 {
                return 50
            }else {
                return 400
            }
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9607843137, alpha: 1)
        return headerView
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
//        view.backgroundColor = UIColor.white
//
//        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 4))
//        separatorView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
//
//        let label = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.size.width, height: 48))
//        label.textColor = UIColor.black
//        //        hexStringToUIColor(hex: ControlSettings.appMainColor)
//        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//
//        if section == 0{
//            label.text = NSLocalizedString("Pro Users", comment: "Pro Users")
//
//        }
//        //        else if section == 2 {
//        //            label.text = NSLocalizedString("", comment: "")
//        //        }
//        else if section == 1 {
//            label.text = NSLocalizedString("Trending HashTags", comment: "Trending HashTags")
//        }
//        else if section == 2 {
//            let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivitiesThreeTableItem" ) as! ActivitiesThreeTableItem
//            headerView.vc = self
//            return headerView
//            //            label.text = NSLocalizedString("Activities", comment: "Activities")
//        }
//        view.addSubview(separatorView)
//        view.addSubview(label)
//        return view
//
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 2
        }else {
            if section == 0 {
                if self.proUsers.isEmpty {
                    return CGFloat.leastNonzeroMagnitude
                }
            }else if section == 1 {
                if self.trending_hashtag.isEmpty {
                    return CGFloat.leastNonzeroMagnitude
                }
            }else if section == 2 {
                if self.lastActivitiesArray.isEmpty {
                    return CGFloat.leastNonzeroMagnitude
                }
            }else if section == 3{
                if self.lastActivitiesArray.isEmpty {
                    return CGFloat.leastNonzeroMagnitude
                }
            }
            else if section == 4{
                guard let _ = self.blogs else { return CGFloat.leastNonzeroMagnitude}
            }
            return 5
        }
    }
}

extension TrendingVC_UI: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//            return 120
//        }else{
//            return 0
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 1 + trending_hashtag.count
        }
//        else if section == 2 {
//            return 1 + lastActivitiesArray.count
//        }
//        else if section == 2 {
//            return 1
//        }
        else if section == 2 {
            guard let blogsCount = blogs?.count else { return 0}
            return 1 + blogsCount
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingHeaderCells", for: indexPath) as! TrendingHeaderCells
                cell.titleLabel.text = "Pro User"
                cell.seeAllButton.isHidden = true
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesSectionOneTableitem") as! ActivitiesSectionOneTableitem
                cell.bind(self.proUsers)
//                let index = indexPath.section
                cell.didSelectItemAction = {[weak self] indexPath in
                    self?.gotoUserProfile(indexPath: indexPath)
                }
                return cell
            }
        //        case 1:
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestcell") as! FriendRequestCell
        //            let index = self.friendRequests[indexPath.row]
        //            if (self.friendRequests.count == 1){
        //                cell.image2.isHidden = true
        //                cell.image3.isHidden = true
        //                if let pro_url = index["avatar"] as? String{
        //                    let url = URL(string: pro_url)
        //                    cell.image1.sd_setImage(with: url, completed: nil)
        //                }
        //            }
        //            else if (self.friendRequests.count == 2){
        //                 cell.image3.isHidden = true
        //                if let pro_url1 = index["avatar"] as? String{
        //                    let url = URL(string: pro_url1)
        //                    cell.image1.sd_setImage(with: url, completed: nil)
        //                }
        //                if let pro_url2 = self.friendRequests[1]["avatar"] as? String{
        //                    let url = URL(string: pro_url2)
        //                    cell.image1.sd_setImage(with: url, completed: nil)
        //                }
        //            }
        //            else if (self.friendRequests.count == 0){
        //                print("Nothing")
        //            }
        //            else{
        //                if let pro_url1 = self.friendRequests[0]["avatar"] as? String{
        //                    let url = URL(string: pro_url1)
        //                    cell.image1.sd_setImage(with: url, completed: nil)
        //                }
        //                if let pro_url2 = self.friendRequests[1]["avatar"] as? String{
        //                    let url = URL(string: pro_url2)
        //                    cell.image3.sd_setImage(with: url, completed: nil)
        //                }
        //                if let pro_url3 = self.friendRequests[2]["avatar"] as? String{
        //                    let url = URL(string: pro_url3)
        //                    cell.image3.sd_setImage(with: url, completed: nil)
        //                }
        //
        //            }
        //            return cell
        //
        //        case 2:
        //            let cell = UITableViewCell()
        //            return cell
        ////            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesThreeTableItem") as! ActivitiesThreeTableItem
        ////            cell.selectionStyle = .none
        ////            return cell
        case 1:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingHeaderCells", for: indexPath) as! TrendingHeaderCells
                cell.titleLabel.text = "Trending Hashtags"
                cell.seeAllButton.isHidden = true
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell") as! TrendingCell
                let index = self.trending_hashtag[indexPath.row - 1]
                if let tag = index["tag"] as? String{
                    cell.hashLabel.text = "\("#")\(tag)"
                }
                if let totalPost = index["trend_use_num"] as? String{
                    cell.totalPostsLbl.text = "\(totalPost)\(" ")\(NSLocalizedString("Post", comment: "Post"))"
                }
                return cell
            }
//        case 2:
//
//
//            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingHeaderCells", for: indexPath) as! TrendingHeaderCells
//                cell.titleLabel.text = "Trending Hashtags"
//                cell.seeAllButton.isHidden = true
//
//                return cell
//
//            }else {
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesSectionTwoTableItem") as! ActivitiesSectionTwoTableItem
//                cell.selectionStyle = .none
//
//
//
//                let index = self.lastActivitiesArray[indexPath.row - 1]
//                if let activitor = index["activator"] as? [String:Any]{
//                    if let image = activitor["avatar"] as? String{
//                        let url = URL(string: image)
//                        cell.profileImage.kf.setImage(with: url)
//                    }
//
//                }
//                if let descrip = index["activity_text"] as? String{
//                    let attributedTitle = NSMutableAttributedString(string: descrip, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
//                    attributedTitle.append(NSMutableAttributedString(string: descrip, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
//                    cell.titleLabel.attributedText = attributedTitle
//                }
//                if let type = index["activity_type"] as? String{
//                    if type == "commented_post"{
//                        cell.changeIcon.image = UIImage(named: "commentss")
//                    }
//                    else if type == "following"{
//                        //                    cell.changeIcon.image = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
//                    }
//                    else  {
//                        cell.changeIcon.image = #imageLiteral(resourceName: "like-2")
//                    }
//                }
//                //            let object = self.lastActivitiesArray[indexPath.row]
//                ////            cell.bind(object)
//                return cell
//            }
//        case 2 :
//            //weather cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell_UI", for: indexPath) as! WeatherCell_UI
//            cell.setupUI()
//            return cell
            
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingHeaderCells", for: indexPath) as! TrendingHeaderCells
                cell.titleLabel.text = "Latest Blogs"
                cell.seeAllButton.isHidden = true
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingBlogsCells", for: indexPath) as! TrendingBlogsCells
                if let index = self.blogs?[indexPath.row - 1] {
                    cell.setupUI()
                    if (indexPath.row - 1) == 0 {
                        cell.topAnchorConstraint.constant = 0
                    }else {
                        cell.topAnchorConstraint.constant = 15
                    }
                    cell.categoryButton.setTitle("     \(index.categoryName ?? "")     ", for: .normal)
                    cell.categoryButton.backgroundColor = .link
                    cell.categoryButton.layer.cornerRadius = 10
                    cell.blogTitleLabel.text = index.title ?? ""
                    cell.blogDescpLabel.text = index.blogDescription ?? ""
                    cell.shareLabel.text = "\(index.shared ?? "") Shares"
                    cell.commentLabel.text = ""
                    cell.commentLabel.isHidden = true
                    cell.reactionLabel.text = "Reactions"
                   
                    cell.viewsLabel.text = "\(index.view ?? "") Views"
                    let thumURL = URL(string: index.thumbnail ?? "")
                    let userURL = URL(string: index.author?.avatar ?? "")
                    cell.blogImageView.kf.setImage(with: thumURL)
                    cell.userProfileImageView.kf.setImage(with: userURL)
                    cell.usernameLabel.text = "\(index.author?.firstName ?? "") \(index.author?.lastName ?? "")"
                    let time = Double(index.author?.lastseenUnixTime ?? "0.0") ?? 0.0
                    let timeToDate = Date(timeIntervalSince1970: time)
                    cell.userTimeLabel.text = timeToDate.timeAgoSinceDate()
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//
//        if (indexPath.section == 1){
//            let Storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
//            let vc = Storyboard.instantiateViewController(withIdentifier: "FollowRequestVC") as! FollowRequestController
//            vc.friend_Requests = self.friendRequests
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
         if (indexPath.section == 1){
            let index = self.trending_hashtag[indexPath.row - 1]
            let Storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "PostHashTagVC") as! PostHashTagController
            if let tag = index["tag"] as? String{
                vc.hashtag = tag
            }
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.section == 2{
            let index = self.lastActivitiesArray[indexPath.row-1]
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
        }else if indexPath.section == 4 {
            if indexPath.row > 0 {
                let index = indexPath.row - 1
//                guard let object = self.blogs?[index] else { return }
//                let storyBoard = UIStoryboard(name: "Poke-MyVideos-Albums", bundle: nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "BlogDetailsVC") as! BlogDetails
////                vc.blogDetails =
//                self.present(vc, animated: true, completion: nil)

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

extension TrendingVC_UI : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
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

extension TrendingVC_UI: FollowRequestDelegate{
    func follow_request(index: Int) {
        self.friendRequests.remove(at: index)
        self.tableView.reloadData()
    }
}

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "just now"
    }
}
