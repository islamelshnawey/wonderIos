//
//  UserProfileVC.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 11/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD

class UserProfileVC: UIViewController {
    
    let status = Reach().connectionStatus()
    private var off_set: String? = nil
    var user_id: String? = nil
    var userData: [String:Any]? = nil
    var groupArray = [[String:Any]]()
    var followersArray = [[String:Any]]()
    var followingArray = [[String:Any]]()
    var postsArray = [[String : Any]]()
    var pageArray = [[String:Any]]()
    var imagesArray = [[String:Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNetwork()
        fetchData()
    }
    
    func setupNetwork() {
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    /////////////////////////NetWork Connection//////////////////////////
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    
    func fetchData() {
        if let userId = self.userData? ["user_id"] as? String{
            self.user_id = userId
        }
        self.getUserData(userId: self.user_id ?? "" , access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppInstance.instance.vc = "userProfile"
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func sendRequest(user_id: String){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                Follow_RequestManager.sharedInstance.sendFollowRequest(userId: user_id) { (success, authError, error) in
                    if success != nil {
                        self.view.makeToast(success?.follow_status)
                        print(success?.follow_status)
                    }
                    else if authError != nil {
                        self.view.makeToast(authError?.errors.errorText)
                    }
                    else if error != nil {
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setupTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(UINib(nibName: "UserProfileDataCell", bundle: nil), forCellReuseIdentifier: "UserProfileDataCell")
        self.tableView.register(UINib(nibName: "UserProfileDetailsCell", bundle: nil), forCellReuseIdentifier: "UserProfileDetailsCell")
        self.tableView.register(UINib(nibName: "FeaturePostCell", bundle: nil), forCellReuseIdentifier: "FeaturePostCell")
        self.tableView.register(UINib(nibName: "FriendsCells", bundle: nil), forCellReuseIdentifier: "FriendsCells")
        self.tableView.register(UINib(nibName: "GroupCells", bundle: nil), forCellReuseIdentifier: "GroupCells")
        self.tableView.register(UINib(nibName: "AboutMeLabelCell", bundle: nil), forCellReuseIdentifier: "AboutMeLabelCell")
        self.tableView.register(UINib(nibName: "SearchPostProfileCell", bundle: nil), forCellReuseIdentifier: "SearchPostProfileCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        SetUpcells.setupCells(tableView: self.tableView)
    }
    
    private func getUserData (userId : String, access_token : String) {
        switch status {
        case .unknown, .offline:
            self.view.makeToast("InternetConnectionFialed")
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                Get_User_DataManagers.sharedInstance.get_User_Data(userId: userId, access_token : access_token) {[weak self] (success, authError, error) in
                    if success != nil {
                        guard let succ = success else { return }
                        self?.followersArray = succ.followers
                        self?.groupArray = succ.joined_groups
                        self?.pageArray = succ.liked_pages
                        for l in succ.following{
                            self?.followingArray.append(l)
                        }
                        self?.userData = success?.user_data
                        print(self?.userData)
                        self?.tableView.reloadData()
                        self?.getImages(user_Id: self?.user_id ?? "")
                    }
                    
                    else if (authError != nil) {
                        ZKProgressHUD.dismiss()
                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error != nil {
                        ZKProgressHUD.dismiss()
                        print("InternalError")
                        self?.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getImages (user_Id : String) {
        switch status {
        case .unknown, .offline:
            self.view.makeToast("InternetConnection Failed")
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                Get_User_ImageManager.sharedInstance.getUserImages(user_id: user_Id, param: "photos") {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data {
                            self?.imagesArray.append(i)
                        }
                        self?.tableView.reloadData()
                        self?.getUserPostsData(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit:10, offset: self?.off_set ?? "", ids: self?.user_id ?? "")
                    }
                    
                    else if authError != nil {
                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error != nil {
                        print("InternalError")
                    }
                }
            }
        }
    }
    
    private func  getUserPostsData (access_token : String, limit : Int, offset : String, ids : String) {
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                Get_Users_Posts_DataManager.sharedInstance.get_User_PostsData(access_token: access_token, limit: limit, id: ids, off_set: offset) { [weak self] (success, authError, error) in
                    if (success != nil) {
                        guard let succ = success else { return }
                        self?.postsArray = succ.data
                        self?.off_set = self?.postsArray.last?["post_id"] as? String ?? "0"
                        //                        self?.spinner.stopAnimating()
                        self?.tableView.reloadData()
                        ZKProgressHUD.dismiss()
                    }
                    else if (authError != nil) {
                        ZKProgressHUD.dismiss()
                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error != nil {
                        ZKProgressHUD.dismiss()
                        print("InternalError")
                        
                    }
                    
                }
            }
        }
    }
    
    func goToMore(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GotoMore") as! MoreViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.delegate1 = self
        if let user_Id = self.userData?["user_id"] as? String{
            vc.userId = user_Id
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension UserProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 1 + 1
        }
        else if section == 3 {
            return 5 + 1
        }else if section == 4 {
            return 1 + 1
        }else if section == 5{
            return 1 + 1
        }else if section == 6 {
            return 1 + 1
        }else if section == 7 {
            return 1 + 1
        }else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9 + self.postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //profile header
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            cell.vc = self
            if let userdata = self.userData {
                cell.bind(userData: userdata)
            }
            return cell
        }else if indexPath.section == 1 {
            //proifle number details
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileDataCell", for: indexPath) as! UserProfileDataCell
            if let userdata = self.userData {
                cell.bind(userData: userdata)
            }
            return cell
        }else if indexPath.section == 2{
            //about me
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "About Me"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeLabelCell", for: indexPath) as! AboutMeLabelCell
                if let about = self.userData?["about"] as? String{
                    if about == "" {
                        cell.aboutMeLabel.text = "N/A"
                    }else {
                        cell.aboutMeLabel.text = about
                    }
                }else {
                    cell.aboutMeLabel.text = "N/A"
                }
                return cell
            }
        }
        else if indexPath.section == 3{
            //profile details
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Profile Details"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileDetailsCell", for: indexPath) as! UserProfileDetailsCell
                let website = self.userData?["website"] as? String
                let gender = self.userData?["gender"] as? String
                let birthday = self.userData?["birthday"] as? String
                let work = self.userData?["working"] as? String
                let address = self.userData?["address"] as? String
                if indexPath.row == 1 {
                    cell.profileImageView.image = R.image.language()
                    cell.profileLabel.text = website ?? "N/A"
                }else if indexPath.row == 2{
                    cell.profileImageView.image = R.image.sex()
                    if gender == "male" {
                        cell.profileLabel.text = "Male"
                    }else if gender == "female"{
                        cell.profileLabel.text = "Female"
                    }else {
                        cell.profileLabel.text = "N/A"
                    }
                }else if indexPath.row == 3{
                    cell.profileImageView.image = R.image.birthdayCake2()
                    cell.profileLabel.text = birthday ?? "N/A"
                }else if indexPath.row == 4{
                    cell.profileImageView.image = R.image.suitcase()
                    cell.profileLabel.text = "Working at \(work ?? "N/A")"
                }else {
                    cell.profileImageView.image = R.image.home1()
                    cell.profileLabel.text = "Living in \(address ?? "N/A")"
                }
                return cell
            }
        }
        else if indexPath.section == 4{
            //feature post
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Feature Posts"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturePostCell", for: indexPath) as! FeaturePostCell
                cell.vc = self
                cell.bind(featurePost: self.imagesArray)
                return cell
            }
        }
        else if indexPath.section == 5{
            //friends
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Friends"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCells", for: indexPath) as! FriendsCells
                cell.vc = self
                cell.bind(data: self.followersArray)
                return cell
            }
        }
        else if indexPath.section == 6{
            //groups
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Groups"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCells", for: indexPath) as! GroupCells
                cell.vc = self
                cell.bind(groups: self.groupArray)
                return cell
            }
        }
        else if indexPath.section == 7{
            //liked pages
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Pages Liked"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCells", for: indexPath) as! GroupCells
                cell.vc = self
                cell.bind(groups: self.pageArray)
                return cell
            }
        }
        else if indexPath.section == 8{
            //search post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPostProfileCell", for: indexPath) as! SearchPostProfileCell
            cell.vc = self
            return cell
        }else{
            //remain post
            var cell = UITableViewCell()
            let index = self.postsArray[indexPath.section - 9]
            let indxPath = IndexPath(row: indexPath.section - 9, section: 0)
            var shared_info : [String:Any]? = nil
            var fundDonation: [String:Any]? = nil
            
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
            if let sharedInfo = index["shared_info"] as? [String:Any] {
                shared_info = sharedInfo
            }
            if let fund = index["fund_data"] as? [String:Any]{
                fundDonation = fund
            }
            if (shared_info != nil){
                cell = GetPostShare.sharedInstance.getsharePost(targetController: self, tableView: self.tableView, indexpath: indxPath, postFile: postfile, array: self.postsArray)
            }
            
           else if (postfile != "")  {
                let url = URL(string: postfile)
                let urlExtension: String? = url?.pathExtension
                if (urlExtension == "jpg" || urlExtension == "png" || urlExtension == "jpeg" || urlExtension == "JPG" || urlExtension == "PNG"){
                    cell = GetPostWithImage.sharedInstance.getPostImage(targetController: self, tableView: tableView, indexpath: indxPath, postFile: postfile, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                    
                else if(urlExtension == "wav" ||  urlExtension == "mp3" || urlExtension == "MP3"){
                    cell = GetPostMp3.sharedInstance.getMP3(targetController: self, tableView: tableView, indexpath: indxPath, postFile: postfile, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                else if (urlExtension == "pdf") {
                    cell = GetPostPDF.sharedInstance.getPostPDF(targetControler: self, tableView: tableView, indexpath: indxPath, postfile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                    
                }
                    
                else {
                    cell = GetPostVideo.sharedInstance.getVideo(targetController: self, tableView: tableView, indexpath: indxPath, postFile: postfile, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                
                
            }
                
            else if (postLink != "") {
                cell = GetPostWithLink.sharedInstance.getPostLink(targetController: self, tableView: tableView, indexpath: indxPath, postLink: postLink, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (postYoutube != "") {
                cell = GetPostYoutube.sharedInstance.getPostYoutub(targetController: self, tableView: tableView, indexpath: indxPath, postLink: postYoutube, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (blog != "0") {
                cell = GetPostBlog.sharedInstance.GetBlog(targetController: self, tableView: tableView, indexpath: indxPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (group != false){
                cell = GetPostGroup.sharedInstance.GetGroupRecipient(targetController: self, tableView: tableView, indexpath: indxPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (product != "0") {
                cell = GetPostProduct.sharedInstance.GetProduct(targetController: self, tableView: tableView, indexpath: indxPath, postFile: "", array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else if (event != "0") {
                cell = GetPostEvent.sharedInstance.getEvent(targetController: self, tableView: tableView, indexpath: indxPath, postFile: "", array:  self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (postSticker != "") {
                cell = GetPostSticker.sharedInstance.getPostSticker(targetController: self, tableView: tableView, indexpath: indxPath, postFile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else if (colorId != "0"){
                cell = GetPostWithBg_Image.sharedInstance.postWithBg_Image(targetController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (multi_image != "0") {
                cell = GetPostMultiImage.sharedInstance.getMultiImage(targetController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else if photoAlbum != "" {
                cell = getPhotoAlbum.sharedInstance.getPhoto_Album(targetController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if postOptions != "0" {
                cell = GetPostOptions.sharedInstance.getPostOptions(targertController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if postRecord != ""{
                cell = GetPostRecord.sharedInstance.getPostRecord(targetController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if fundDonation != nil{
                cell = GetDonationPost.sharedInstance.getDonationpost(targetController: self, tableView: tableView, indexpath: indxPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else {
                cell = GetNormalPost.sharedInstance.getPostText(targetController: self, tableView: tableView, indexpath: indxPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //profile header
            return 430
        }else if indexPath.section == 1 {
            //profle number details
            return 65
        }else if indexPath.section == 2{
            //about me
            return indexPath.row == 0 ? 40 : UITableView.automaticDimension
        }
        else if indexPath.section == 3{
            //profile details
            return indexPath.row == 0 ? 30 : 45
        }
        else if indexPath.section == 4{
            //feature post
            if self.imagesArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return indexPath.row == 0 ? 40 : 150
        }
        else if indexPath.section == 5{
            //friends
            if self.followersArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return indexPath.row == 0 ? 40 : 70
        }
        else if indexPath.section == 6{
            //groups
            if self.groupArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return indexPath.row == 0 ? 40 : 200
        }
        else if indexPath.section == 7{
            //liked pages
            if self.pageArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return indexPath.row == 0 ? 40 : 200
        }
        else if indexPath.section == 8{
            //search post cell
            return 60
        }else{
            //remain post
            if self.postsArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.row != 0 {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        else if section == 4{
            //feature post
            if self.imagesArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
        }
        else if section == 5{
            //friends
            if self.followersArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
        }
        else if section == 6{
            //groups
            if self.groupArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
        }
        else if section == 7{
            //liked pages
            if self.pageArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
        }else if section == 9{
            //remain post
            if self.postsArray.isEmpty {
                return CGFloat.leastNonzeroMagnitude
            }
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView()
        headerview.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9607843137, alpha: 1)
        return headerview
    }
}

extension UserProfileVC: blockUserDelegate {
    
    func block() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserProfileVC: ProfileMoreDelegate {

    func profileMore(tag: Int) {
        var profileUrl: String? = nil
        if let url = self.userData?["url"] as? String{
            profileUrl = url
        }
        
        if tag == 1{
            UIPasteboard.general.string = profileUrl ?? ""
            self.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
        }
        else if tag == 2{
            let textToShare = [ profileUrl ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else if tag == 3{
            print("Poke")
            switch status {
            case .unknown, .offline:
                self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            case .online(.wwan),.online(.wiFi):
                CreatePokeManager.sharedInstance.createPokes(user_Id: self.userData?["user_id"] as! String) { (success, authError, error) in
                    if success != nil {
                        self.view.makeToast("Poked")
                    }
                    else if authError != nil  {
                        self.view.makeToast(authError?.errors.errorText)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                    
                }
            }
        }
        else if tag == 4{
            print("Add to Family")
        }
        else if tag == 5{
            let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectGIFVC") as! SelectGIFVC
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
           
        }
    }
}

extension UserProfileVC: didSelectGIFDelegate {
    
    func didSelectGIF(GIFUrl: String,id: String) {
        print(GIFUrl)
        print(id)
        SendGiftManager.sharedInstance.sendGiftManager(user_id:self.user_id ?? "" , id: "1" ?? "1") { (success, authError, error) in
            if success != nil{
                self.view.makeToast("Done")
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
