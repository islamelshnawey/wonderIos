
import UIKit
import WoWonderTimelineSDK
import Kingfisher
import Toast_Swift
import NotificationCenter
import GoogleMobileAds
import AVFoundation

class MyProfileController: UIViewController,ProfileMoreDelegate,editPostDelegate{

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let status = Reach().connectionStatus()
    let Storyboards = UIStoryboard(name: "MoreSection", bundle: nil)
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var userData = [String:Any]()
    var pagesArray = [[String:Any]]()
    var groupsArray = [[String:Any]]()
    var familyArray = [[String:Any]]()
    var postsArray = [[String:Any]]()
    var off_set: String? = nil
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    var is_Profile = 2
    var profileImageURL = ""
    var coverImageURL = ""
    var selectedIndex = 0
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "click_sound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.tableView.register(UINib(nibName: "MyProfileCell", bundle: nil), forCellReuseIdentifier: "MyProfile")
        self.tableView.register(UINib(nibName: "PostLiveCell", bundle: nil), forCellReuseIdentifier: "LiveCell")
        self.tableView.register(UINib(nibName: "SearchPostCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        SetUpcells.setupCells(tableView: self.tableView)
//        self.userData.updateValue(AppInstance.instance.profile?.userData?.avatar ?? "", forKey: "avatar")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)

        let deatails: [String:Any] = ["followers_count":AppInstance.instance.profile?.userData?.details?.followersCount ?? 0,"following_count":AppInstance.instance.profile?.userData?.details?.followingCount ?? 0,"likes_count":AppInstance.instance.profile?.userData?.details?.likesCount ?? 0]
        
        self.userData = ["name":UserData.getUSER_NAME() ?? "","wallet":UserData.getWallet() ?? "" ,"is_pro":UserData.getIsPro() ?? "","avatar":UserData.getImage() ?? "","cover":AppInstance.instance.profile?.userData?.cover ?? "","about":AppInstance.instance.profile?.userData?.about ?? "", "details":deatails,"points":AppInstance.instance.profile?.userData?.points ?? 0]
        self.activityIndicator.startAnimating()
        self.getProfile()
        if ControlSettings.shouldShowAddMobBanner{
                   bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                   addBannerViewToView(bannerView)
                   bannerView.adUnitID = ControlSettings.addUnitId
                   bannerView.rootViewController = self
                   bannerView.load(GADRequest())
//                   interstitial = GADInterstitialAd(adUnitID:  ControlSettings.interestialAddUnitId)
//                   let request = GADRequest()
//                   interstitial.load(request)
            GADInterstitialAd.load()
               }
    }
    func CreateAd() -> GADInterstitialAd {
          let interstitial = GADInterstitialAd()
//          interstitial.load(GADRequest())
          return interstitial
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
    override func viewWillAppear(_ animated: Bool) {
//        print(UserData.getUSER_NAME()!)
        AppInstance.instance.vc = "myProfile"
        NotificationCenter.default.addObserver(self, selector: #selector(self.Notifire(notification:)), name: NSNotification.Name(rawValue: "Notifire"), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
     NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Notifire"), object: nil)
        self.tabBarController?.tabBar.isHidden = false
    }

    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }
    
    func editPost(newtext: String, postPrivacy: String) {
        self.postsArray[self.selectedIndex]["postText"] = newtext
        self.postsArray[self.selectedIndex]["postPrivacy"] = postPrivacy
        self.tableView.reloadData()
    }
    
    
    
    @objc func loadList(notification: NSNotification){
        var post_id = ""
        if let data = notification.userInfo?["data"] as? [String:Any] {
            if let id = data["post_id"] as? String{
                post_id = id
            }
            switch status {
            case .unknown, .offline:
                self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            case .online(.wwan), .online(.wiFi):
                performUIUpdatesOnMain {
            Get_Users_Posts_DataManager.sharedInstance.get_User_PostsData(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)" , limit: 5, id: UserData.getUSER_ID()!, off_set: "") {[weak self] (success, authError, error) in
                        if success != nil {
                            for i in success!.data{
                                if i["post_id"] as? String == post_id{
                                    self?.postsArray.insert(i, at: 0)
                                }
                            }
                            self?.audioPlayer.play()
                            self?.spinner.stopAnimating()
                            self?.activityIndicator.stopAnimating()
                            self?.tableView.reloadData()
                        }
                        else if authError != nil {
                            self?.showAlert(title: "", message: (authError?.errors.errorText)!)
                        }
                        else if error != nil {
                            print(error?.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    @objc func Notifire(notification: NSNotification){
        if let type = notification.userInfo?["type"] as? String{
            if type == "delete"{
                if let data = notification.userInfo?["userData"] as? Int{
                    print(data)
                    self.postsArray.remove(at: data)
                    self.tableView.reloadData()
                }
            }
            else if (type == "profile"){
                if let data = notification.userInfo?["userData"] as? Int{
                    print(data)
                    print("Nothing")
                }
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
            else if (type == "share"){
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                var groupId: String? = nil
                var pageId: String? = nil
                var user_data: [String:Any]? = nil
                if let data = notification.userInfo?["userData"] as? Int{
                    if let shared_info = self.postsArray[data]["shared_info"] as? [String:Any]{
                        if shared_info != nil{
                            if let groupid = self.postsArray[data]["group_id"] as? String{
                                groupId = groupid
                            }
                            if let page_Id = self.postsArray[data]["page_id"] as? String{
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
                                if let groupid = self.postsArray[tag]["group_id"] as? String{
                                    groupId = groupid
                                }
                                if let page_Id = self.postsArray[tag]["page_id"] as? String{
                                    pageId = page_Id
                                }
                                if let userData = self.postsArray[tag]["publisher"] as? [String:Any]{
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
        }
    }
    
    private func getProfile(){
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            DispatchQueue.main.async {
                Get_User_DataManagers.sharedInstance.get_User_Data(userId: UserData.getUSER_ID()!, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)") { [weak self] (success, authError, error) in
                    if success != nil {
                        self?.userData = success!.user_data
                        self?.pagesArray = (success!.liked_pages.map({$0}))
                        self?.groupsArray = success!.joined_groups.map({$0})
                        self?.tableView.reloadData()
                        self?.getPost()
                        if let Wallet = self?.userData["wallet"] as? String{
                            UserData.setWallet(Wallet)
                        }
                    }
                    else if authError != nil {
                        self?.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getPost() {
        switch status {
        case .unknown, .offline:
            print("Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                Get_Users_Posts_DataManager.sharedInstance.get_User_PostsData(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)" , limit: 10, id: UserData.getUSER_ID()!, off_set: self.off_set ?? "") {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            self?.postsArray.append(i)
                        }
                        self?.off_set = self?.postsArray.last?["post_id"] as? String ?? "0"
                        self?.spinner.stopAnimating()
                        self?.activityIndicator.stopAnimating()
                        self?.tableView.reloadData()
                    }
                    else if authError != nil {
                        self?.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func uploadImage(imageType:String,data:Data){
        performUIUpdatesOnMain {
            UpdateUserDataManager.sharedInstance.uploadUserImage(imageType: imageType, data: data) { (success, authError, error) in
                if success != nil {
                    self.view.makeToast(success?.message)
                    AppInstance.instance.getProfile()
                }
                else if authError != nil{
                    self.view.makeToast(authError?.errors.errorText)
                }
                else if error != nil{
                    self.view.makeToast(error?.localizedDescription)
                }
            }
        }
    }
    
    func profileMore(tag: Int) {
        var profileUrl: String? = nil
        if let url = self.userData["url"] as? String{
            profileUrl = url
        }
        if tag == 0{
            UIPasteboard.general.string = profileUrl ?? ""
            self.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
        }
        else if tag == 1{
            let textToShare = [ profileUrl ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else if (tag == 2){
            let storyboard = UIStoryboard(name: "Privacy", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (tag == 3){
            let storyboard = UIStoryboard(name: "General", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GeneralVC") as! GeneralVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (tag == 4){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpgradeVC") as! UpgradeController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (tag == 5){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LastActivityVC") as! LastActivitesController
            vc.isFromProfile = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            print("nothing")
        }
    }
    @objc func GotoAddPost(sender: UIButton){
        let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostVC") as! AddPostVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyProfileController : UITableViewDelegate,UITableViewDataSource,EditProfileDelegate,uploadImageDelegate,changeProfilePicDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
            
        else{
            return self.postsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfile") as! MyProfileCell
              var isPro: String? = nil
              var isVerfied: String? = nil
              var userName: String? = nil
            var live = ""
            if let details = self.userData["details"] as? [String:Any]{
                if let followers = details["followers_count"] as? String{
                    cell.followerBtn.setTitle(followers, for: .normal)
                }
                if let following = details["following_count"] as? String{
                    cell.followingBtn.setTitle(following, for: .normal)
                }
                if let Likes = details["likes_count"] as? String{
                    cell.likeBtn.setTitle(Likes, for: .normal)
                }
            }
            if let user_name = userData["name"] as? String{
                userName = user_name
            }
            if let about = userData["about"] as? String{
                if about == ""{
                    cell.statusTextLbl.text = NSLocalizedString("Hi there! i am using Wowonder", comment: "Hi there! i am using Wowonder")
                }
                else{
                cell.statusTextLbl.text = about
                }
            }
            if let Points = userData["points"] as? String{
                cell.pointBtn.setTitle(Points, for: .normal)
            }
            if let profileImage = userData["avatar"] as? String{
                let url = URL(string: profileImage)
                cell.profileImage.kf.setImage(with: url)
            }
            if let coverImage = userData["cover"] as? String{
                let url = URL(string: coverImage)
                cell.coverImage.kf.setImage(with: url)
            }
            if let wallet = userData["wallet"] as? String{
                cell.walletBtn.setTitle("\("  ")\(wallet)\(" ")", for: .normal)
            }
            if let is_Pro = userData["is_pro"] as? String{
                isPro = is_Pro
            }
            if let is_Verified = userData["verified"] as? String{
                isVerfied = is_Verified
            }
                let imageAttachment =  NSTextAttachment()
                let imageAttachment1 =  NSTextAttachment()
                imageAttachment.image = UIImage(named:"veirfied")
                imageAttachment1.image = UIImage(named: "pros")
                let imageOffsetY: CGFloat = -2.0
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            imageAttachment1.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment1.image!.size.width, height: imageAttachment1.image!.size.height)
                
                let attechmentString = NSAttributedString(attachment: imageAttachment)
                let attechmentString1 = NSAttributedString(attachment: imageAttachment1)
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.white]
                let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.white]
                if isPro == "1"{
                let attributedString1 = NSMutableAttributedString(string: "\(userName ?? "")\("  ")", attributes:attrs1)
                let attributedString2 = NSMutableAttributedString(attributedString: attechmentString)
                let attributedString3 = NSMutableAttributedString(string: " ", attributes:attrs2)
                let attributedString4 = NSMutableAttributedString(attributedString: attechmentString1)
                attributedString1.append(attributedString2)
                attributedString1.append(attributedString3)
                attributedString1.append(attributedString4)
                    cell.nameLabel.attributedText = attributedString1
                }
                else{
                    cell.nameLabel.text = userName
                }
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showProfileImage(gesture:)))
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.showCoverImage(gesture:)))
            cell.backBtn.addTarget(self, action: #selector(self.Back), for: .touchUpInside)
            cell.editProfileBtn.addTarget(self, action: #selector(self.EditProfile), for: .touchUpInside)
            cell.changeImageBtn.addTarget(self, action: #selector(self.ChangePicture), for: .touchUpInside)
            cell.moreBtn.addTarget(self, action: #selector(self.GotoMore), for: .touchUpInside)
            cell.followingBtn.addTarget(self, action: #selector(self.gotoFollowingVC(sender:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(self.gotoMyPages), for: .touchUpInside)
            cell.followerBtn.addTarget(self, action: #selector(self.gotoFollowersVC(sender:)), for: .touchUpInside)
            cell.walletBtn.addTarget(self, action: #selector(self.gotoWalletVC(sender:)), for: .touchUpInside)
            cell.profileImage.addGestureRecognizer(gesture)
            cell.profileImage.isUserInteractionEnabled = true
            cell.coverImage.addGestureRecognizer(gesture1)
            cell.coverImage.isUserInteractionEnabled = true
            self.tableView.rowHeight = 325.0
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostStatus") as! PostStatusCell
            let url = URL(string: AppInstance.instance.profile?.userData?.avatar ?? "")
            print(url)
            cell.profileImage.kf.setImage(with:url)
            self.tableView.rowHeight = 80.0
            return cell
        }
        else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchPostCell
            self.tableView.rowHeight = 70.0
            return cell
        }
        else if (indexPath.section == 3){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else if (indexPath.section == 4){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else if (indexPath.section == 5){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
            
        else {
         
            var cell = UITableViewCell()
            let index = self.postsArray[indexPath.row]
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
                cell = GetPostShare.sharedInstance.getsharePost(targetController: self, tableView: self.tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray)
            }
            else if (live == "live"){
                let cells = tableView.dequeueReusableCell(withIdentifier: "LiveCell") as! PostLiveCell
//                self.tableView.rowHeight = 350.0
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 350.0
                cells.bind(index: index, indexPath: indexPath.row)
                cells.vc = self
                cell = cells
            }
            else if (postfile != "")  {
                let url = URL(string: postfile)
                let urlExtension: String? = url?.pathExtension
                if (urlExtension == "jpg" || urlExtension == "png" || urlExtension == "jpeg" || urlExtension == "JPG" || urlExtension == "PNG"){
                    cell = GetPostWithImage.sharedInstance.getPostImage(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                    
                else if(urlExtension == "wav" ||  urlExtension == "mp3" || urlExtension == "MP3"){
                    cell = GetPostMp3.sharedInstance.getMP3(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                else if (urlExtension == "pdf") {
                    cell = GetPostPDF.sharedInstance.getPostPDF(targetControler: self, tableView: tableView, indexpath: indexPath, postfile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                    
                }
                    
                else {
                    cell = GetPostVideo.sharedInstance.getVideo(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                }
                
                
            }
                
            else if (postLink != "") {
                cell = GetPostWithLink.sharedInstance.getPostLink(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postLink, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (postYoutube != "") {
                cell = GetPostYoutube.sharedInstance.getPostYoutub(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postYoutube, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (blog != "0") {
                cell = GetPostBlog.sharedInstance.GetBlog(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (group != false){
                cell = GetPostGroup.sharedInstance.GetGroupRecipient(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (product != "0") {
                cell = GetPostProduct.sharedInstance.GetProduct(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else if (event != "0") {
                cell = GetPostEvent.sharedInstance.getEvent(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array:  self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if (postSticker != "") {
                cell = GetPostSticker.sharedInstance.getPostSticker(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else if (colorId != "0"){
                cell = GetPostWithBg_Image.sharedInstance.postWithBg_Image(targetController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if (multi_image != "0") {
                cell = GetPostMultiImage.sharedInstance.getMultiImage(targetController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else if photoAlbum != "" {
                cell = getPhotoAlbum.sharedInstance.getPhoto_Album(targetController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if postOptions != "0" {
                cell = GetPostOptions.sharedInstance.getPostOptions(targertController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if postRecord != ""{
                cell = GetPostRecord.sharedInstance.getPostRecord(targetController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            else if fundDonation != nil{
            cell = GetDonationPost.sharedInstance.getDonationpost(targetController: self, tableView: tableView, indexpath: indexPath, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else {
                cell = GetNormalPost.sharedInstance.getPostText(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if AppInstance.instance.addCount == ControlSettings.interestialCount {
////                               if interstitial.isReady {
////                                   interstitial.present(fromRootViewController: self)
////                                   interstitial = CreateAd()
////                                   AppInstance.instance.addCount = 0
////                               } else {
////
////                                   print("Ad wasn't ready")
////                               }
//            interstitial.present(fromRootViewController: self)
//            interstitial = CreateAd()
//            AppInstance.instance.addCount = 0
//                           }
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
            let storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchPostVC") as! SearchPostController
            vc.type = "user"
            vc.id = UserData.getUSER_ID() ?? ""
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
           }
           else {
               print("Didtap")
           }
       }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.postsArray.count >= 10 {
            let count = self.postsArray.count
            let lastElement = count - 1
            
            if indexPath.row == lastElement {
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                self.getPost()
            }
        }
    }
    
    @IBAction func showProfileImage (gesture: UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageController1
        if let profileImage = self.userData["avatar"] as? String{
            vc.imageUrl = profileImage
        }
         vc.is_Menu = "1"
         vc.posts.append(self.userData)
         vc.modalPresentationStyle = .overFullScreen
         vc.modalTransitionStyle = .coverVertical
         self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showCoverImage (gesture: UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageController1
        if let coverImage = self.userData["cover"] as? String{
            vc.imageUrl = coverImage
        }
         vc.is_Menu = "1"
         vc.posts.append(self.userData)
         vc.modalPresentationStyle = .overFullScreen
         vc.modalTransitionStyle = .coverVertical
         self.present(vc, animated: true, completion: nil)
    }
    
    func editProfile(firstName: String, lastName: String, phone: String, webSite: String, WorkPlace: String, School: String, location : String) {
        self.userData["first_name"] = firstName
        self.userData["last_name"]  = lastName
        self.userData["phone_number"]  = phone
        self.userData["address"] = location
        self.userData["working"] = WorkPlace
        self.userData["school"] = School
        self.userData["website"] = webSite
    }
    
    @IBAction func Back(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditProfile(){
        
        let storyboard = UIStoryboard(name: "General", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
//        let navigationVC = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! UINavigationController
//        navigationVC.modalPresentationStyle = .fullScreen
//        navigationVC.modalTransitionStyle = .coverVertical
//        let vc = navigationVC.topViewController as? EditProfileController
//
//        if let firstName = userData["first_name"] as? String{
//            vc?.first_Name = firstName
//        }
//        if let lastName = userData["last_name"] as? String{
//            vc?.last_Name = lastName
//        }
//        if let address = userData["address"] as? String{
//            vc?.addresss = address
//        }
//        if let working = userData["working"] as? String{
//            vc?.work_Place = working
//        }
//        if let school = userData["school"] as? String{
//            vc?.schoolz = school
//        }
//        if let website = userData["website"] as? String{
//            vc?.webSite = website
//        }
//        if let phone = userData["phone_number"] as? String{
//            vc?.phone_Number = phone
//        }
//        vc?.delegate = self
//        self.present(navigationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func ChangePicture() {
        let vc = Storyboards.instantiateViewController(withIdentifier: "changePics") as! ChangedPictureController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    func changePic(image: String) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
        vc.delegate = self
        vc.imageType = image
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func uploadImage(imageType: String, image: UIImage) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! MyProfileCell
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            print(imageType)
            if imageType == "avatar"{
                cell.profileImage.image = image
                let imageData = image.jpegData(compressionQuality: 0.1)
                self.uploadImage(imageType: "avatar", data: (imageData ?? nil)!)
                
            }
            else {
                cell.coverImage.image = image
                let imageData = image.jpegData(compressionQuality: 0.1)
                self.uploadImage(imageType: imageType, data: (imageData ?? nil)!)
            }
        }
    }
    
    
    @IBAction func GotoMore() {
        let vc = Storyboards.instantiateViewController(withIdentifier: "More") as! MoreVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func gotoFollowersVC (sender: UIButton){
        if let details = self.userData["details"] as? [String:Any]{
            if let followersCount = details["followers_count"] as? String{
                if followersCount != "0"{
                    let storyBoard = UIStoryboard(name: "MoreSection", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingController
                    vc.userId = UserData.getUSER_ID()
                    vc.type = "followers"
                    vc.navTitle = NSLocalizedString("Followers", comment: "Followers")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func gotoFollowingVC (sender: UIButton){
        if let details = self.userData["details"] as? [String:Any]{
            if let followingCount = details["following_count"] as? String{
                if followingCount != "0"{
                    let storyBoard = UIStoryboard(name: "MoreSection", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingController
                    vc.userId = UserData.getUSER_ID()
                    vc.type = "following"
                    vc.navTitle = NSLocalizedString("Following", comment: "Following")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func gotoWalletVC(sender: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WalletVC") as! WalletMainController
        if let wallet = userData["wallet"] as? String{
            vc.mybalance = wallet
        }
        if (ControlSettings.showPaymentVC == true){
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func gotoMyPages(){
        if let details = self.userData["details"] as? [String:Any]{
            if let pageLike = details["likes_count"] as? String{
                if pageLike != "0"{
                    let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PageListVC") as! PageListsController
                    vc.user_id = UserData.getUSER_ID()
                    vc.isOwner = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}
