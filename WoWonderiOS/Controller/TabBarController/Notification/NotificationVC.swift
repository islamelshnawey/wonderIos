//
//  NotificationVC.swift
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



class NotificationVC: UIViewController,UITabBarControllerDelegate,loadEventDelegate,createLiveDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noNotiView: UIView!
    @IBOutlet weak var bellIcon: UIImageView!
    @IBOutlet weak var noNotiLbl: UILabel!
    @IBOutlet weak var notextLbl: UILabel!
    
    let spinner = UIActivityIndicatorView(style: .gray)
    let pulltoRefresh = UIRefreshControl()
    var notificationArray = [[String:Any]]()
    let status = Reach().connectionStatus()
    var shouldRefreshStories = false
    var interstitial: GADInterstitialAd!
    var isVideo:Bool? = false
    
    var timer: Timer?
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 40))
    let placeholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.white])
    
    let rightButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        //            UIColor.hexStringToUIColor(hex: "994141")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.bellIcon.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noNotiLbl.text = NSLocalizedString("No Notification yet", comment: "No Notification yet")
        self.notextLbl.text = NSLocalizedString("Stay tuned notifications about your activity will show up here", comment: "Stay tuned notifications about your activity will show up here")
        self.noNotiView.isHidden = true
        self.setupUI()
        if ControlSettings.shouldShowAddMobBanner{
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
            GADInterstitialAd.load()
        }
        
        
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
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title  = NSLocalizedString("Notifications", comment: "Notifications")
        
        self.tabBarController?.delegate = self
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
    
    
    func CreateAd() -> GADInterstitialAd {
        let interstitial = GADInterstitialAd()
//        interstitial.load(GADRequest())
        return interstitial
    }
    override func viewWillAppear(_ animated: Bool) {
        self.rightButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.rightButton.isHidden = true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let tabBarIndex = tabBarController.selectedIndex

        print(tabBarIndex)

        if tabBarIndex == 1 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        self.showStoriesLog()
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
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
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
        self.tableView.separatorStyle = .none
          tableView.register(UINib(nibName: "NotificationsTableItem", bundle: nil), forCellReuseIdentifier: "NotificationsTableItem")
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
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
       // ZKProgressHUD.show("Loading")
        self.activityIndicator.startAnimating()
        SetUpcells.setupCells(tableView: self.tableView)
        self.loadNotification()
        self.timer =  Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.getNotification), userInfo: nil, repeats: true)
        
    }
    
    @objc func getNotification(){
        self.loadNotification()
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
    }
    @objc func refresh(){
        self.notificationArray.removeAll()
        self.tableView.reloadData()
        loadNotification()
        pulltoRefresh.endRefreshing()
        
    }
    private func loadNotification(){
        switch status {
        case .unknown, .offline:
//            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                NotificationManager.instance.getNotification(offset: 0, limit: 20, type: "notifications") { (success, authError, error) in
                    print(success?.notifications)
                    if success != nil {
                        self.notificationArray.removeAll()
                        self.notificationArray = success?.notifications ?? []
                        self.tableView.reloadData()
                        if (self.notificationArray.count == 0){
                            self.noNotiView.isHidden = false
                        }
                        else{
                            self.noNotiView.isHidden = true
                        }
                        self.activityIndicator.stopAnimating()
                        print(self.notificationArray)
                    }
                    else if authError != nil {
//                        ZKProgressHUD.dismiss()
                        self.view.makeToast(authError?.errors?.errorText)
                        self.showAlert(title: "", message: (authError?.errors?.errorText)!)
                    }
                    else if error  != nil {
//                        ZKProgressHUD.dismiss()
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
    
    
}
extension NotificationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.notificationArray.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableItem") as! NotificationsTableItem
        let index = self.notificationArray[indexPath.row]
        if let notifier = index["notifier"] as? [String:Any]{
            if let image = notifier["avatar"] as? String{
                let url = URL(string: image)
                cell.profileImage.kf.setImage(with: url)
            }
            if let name = notifier["name"] as? String{
                cell.titleLabel.text = name
            }
        }
        if let type = index["type"] as? String{
            if type == "joined_group"{
                cell.changeBg.backgroundColor = UIColor.hexStringToUIColor(hex: "3F30FF")
                cell.changeIcon.image = UIImage(named: "tick")
            }
            else if type == "poke"{
                cell.changeBg.backgroundColor = UIColor.hexStringToUIColor(hex: "1F2124")
                cell.changeIcon.image = UIImage(named: "notification")
            }
            else if type == "shared_your_post"{
                cell.changeBg.backgroundColor = UIColor.hexStringToUIColor(hex: "1F2124")
                cell.changeIcon.image = #imageLiteral(resourceName: "Share")
            }
            else{
                cell.changeBg.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
               cell.changeIcon.image = UIImage(named: "like-2")
            }
        }
        if let type_text = index["type_text"] as? String{
            cell.descriptionLabel.text = type_text
        }
        return cell
     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
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
        let index = self.notificationArray[indexPath.row]
        if let Type = index["type"] as? String{
            if (Type == "following" || Type == "visited_profile" || Type == "accepted_request"){
                if let notifier = index["notifier"] as? [String:Any]{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                vc.userData = notifier
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if (Type == "liked_page" || Type == "invited_page" || Type == "accepted_invite"){
                
            }
            else if (Type == "joined_group" || Type == "accepted_join_request" || Type == "added_you_to_group"){
                if let id  = index["group_id"] as? String{
                    let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
                    vc.id = id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if (Type == "going_event"){
                self.shouldRefreshStories = true
                             PPStoriesItemsViewControllerVC = UIStoryboard(name: "Stories", bundle: nil).instantiateViewController(withIdentifier: "StoryItemVC") as! StoryItemVC
                             let vc = PPStoriesItemsViewControllerVC
                             vc.refreshStories = {
                                 //                self.viewModel?.refreshStories.accept(true)
                             }
                             vc.modalPresentationStyle = .overFullScreen
//                             vc.pages = (self.storiesArray)
                             vc.currentIndex = indexPath.row
                          self.present(vc, animated: true, completion: nil)
                
            }
            else if (Type == "viewed_story"){
                
                
            }
            else if (Type == "requested_to_join_group"){
                
            }
            else{
                if let id = index["post_id"] as? String{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ShowPostVC") as! ShowPostController
                    vc.postId = id
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
extension NotificationVC:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}
extension NotificationVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
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
