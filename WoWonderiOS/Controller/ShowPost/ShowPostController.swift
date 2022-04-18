
import UIKit
import Kingfisher
import WoWonderTimelineSDK
import Toast_Swift
import AVFoundation
class ShowPostController: UIViewController,editPostDelegate,AddReactionDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate{


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let status = Reach().connectionStatus()
    var isVideo:Bool = false
    var selectedIndex = 0
    var selectedIndexs = [[String:Any]]()
    
    var comments = [[String:Any]]()
    private var postsArray = [[String:Any]]()
    
    var postId: String? = nil
    var offset: String? = nil
    
    var audioPlayer = AVAudioPlayer()
    var player = AVAudioPlayer()
    var counter = 0
    var timer = Timer()
    var audioIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = NSLocalizedString("Post", comment: "Post")
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        self.activityIndicator.startAnimating()
        self.tableView.tableFooterView = UIView()
        SetUpcells.setupCells(tableView: self.tableView)
        self.tableView.register(UINib(nibName: "CommentCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        self.getPost(postId: self.postId ?? "")
        self.getPostComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    AppInstance.instance.vc = "showPostVC"
    NotificationCenter.default.addObserver(self, selector: #selector(self.Notifire(notification:)), name: NSNotification.Name(rawValue: "Notifire"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Notifire"), object: nil)
       
        if isVideo{
            let indexpathforTextView = IndexPath(row: 0, section: 6)
                                let cell = tableView.cellForRow(at: indexpathforTextView)! as! VideoCell
            cell.playerView.pause()
        }
    }
   
    
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    
    func editPost(newtext: String, postPrivacy: String) {
        self.postsArray[self.selectedIndex]["postText"] = newtext
        self.postsArray[self.selectedIndex]["postPrivacy"] = postPrivacy
        self.tableView.reloadData()
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
            if type == "profile"{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                var groupId: String? = nil
                var pageId: String? = nil
                var user_data: [String:Any]? = nil
                if let data = notification.userInfo?["userData"] as? Int{
                    print(data)
                    if let groupid = self.postsArray[data]["group_id"] as? String{
                        groupId = groupid
                    }
                    if let page_Id = self.postsArray[data]["page_id"] as? String{
                        pageId = page_Id
                    }
                    if let userData = self.postsArray[data]["publisher"] as? [String:Any]{
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
            if type == "edit"{
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
        }
    }
    
    
    private func getPost(postId: String){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetPostByIdManager.sharedInstance.getPost(post_id: postId) { (success, authError, error) in
                    if success != nil{
                        self.postsArray.append(success!.post_data)
                        let delayTime = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                        
                        print(self.postsArray)
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
    }
    
    
    @objc func playingAudio(sender:UIButton){
        if self.player.isPlaying == true{
            self.timer.invalidate()
            self.counter = 0
            self.player.stop()
            let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 7)) as! CommentCellTableViewCell
            cell.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else{
        self.timer.invalidate()
        self.counter = 0
        self.audioIndex = sender.tag
        self.player.stop()
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 7)) as! CommentCellTableViewCell
        let record = self.comments[sender.tag]["record"] as? String ?? ""
        cell.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        let url = URL(string: record)
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url!, completionHandler: { [weak self](URL, response, error) -> Void in
            if error == nil{
                var error : NSError?
                do {
                    let player = try AVAudioPlayer(contentsOf: URL!)
                    self?.player = player
                    
                } catch {
                    print(error)
                }
                if let err = error{
                    print("audioPlayer error: \(err.localizedDescription)")
                }else{
                    self?.player.play()
                    self?.player.delegate = self
                    DispatchQueue.main.async {
                        self?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.timerAction), userInfo: nil, repeats: true)
                    }
                    
                }
                
    print("playing \(url)")
            }
            else{
                print(error?.localizedDescription)
            }
        })
        downloadTask.resume()
    }
    }
    
    @objc func timerAction(){
        let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 7)) as! CommentCellTableViewCell
        counter += 1
        let str = String(format: "%02d", arguments: [counter ?? 0])
        cell.audioTimer.text = "00:\(str)"
//        cell.audioTimer.text = "00:\(counter)"
    }

    
    
    private func getPostComments(){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                FetchCommentManager.sharedInstance.fetchComment(postId: self.postId ?? "", offset: self.offset ?? "") { (success, authError, error) in
                    if success != nil {
                        self.comments.removeAll()
                        for i in success!.data {
                            self.comments.append(i)
                        }
                        
                        print(self.comments.count)
                        let delayTime = DispatchTime.now() + 3
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                            self.tableView.reloadData()
                        }
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
    
    private func likeComment(commentId: String,type: String) {
        LikeCommentManager.sharedIntsance.likeComment(commentId: commentId, type: type) { (success, authError, error) in
            if success != nil {
                print(success?.api_status)
            }
            else if authError != nil {
                print(authError?.errors.errorText)
            }
            else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
}

extension ShowPostController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else if section == 3{
            return 1
        }
        else if section == 4{
            return 1
        }
        else if section == 5{
            return 1
        }
        else if section == 6{
            return self.postsArray.count
        }
        else {
            if self.comments.isEmpty == true || self.comments.count == 0{
                  return 1
            }
            else{
                 return self.comments.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = UITableViewCell()
             self.tableView.rowHeight = 0
             return cell
        }
        else if (indexPath.section == 1){
            let cell = UITableViewCell()
             self.tableView.rowHeight = 0
             return cell
        }
        else if (indexPath.section == 2){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
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
        else if (indexPath.section == 6){
        let index = self.postsArray[indexPath.row]
        var cell = UITableViewCell()
        var shared_info : [String:Any]? = nil
        var fundDonation: [String:Any]? = nil
        
        let postfile = index["postFile"] as? String ?? ""
              let postFile_full = index["postFile_full"] as? String ?? ""
            
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
            cell = GetPostShare.sharedInstance.getsharePost(targetController: self, tableView: self.tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray)
        }
        
       else if (postfile != "")  {
            let url = URL(string: postfile)
            let urlExtension: String? = url?.pathExtension
            if (urlExtension == "jpg" || urlExtension == "png" || urlExtension == "jpeg" || urlExtension == "JPG" || urlExtension == "PNG"){
                cell = GetPostWithImage.sharedInstance.getPostImage(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if(urlExtension == "wav" ||  urlExtension == "mp3" || urlExtension == "MP3"){
                cell = GetPostMp3.sharedInstance.getMP3(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else if (urlExtension == "pdf") {
                cell = GetPostPDF.sharedInstance.getPostPDF(targetControler: self, tableView: tableView, indexpath: indexPath, postfile: postfile, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else {
                cell = GetPostVideo.sharedInstance.getVideo(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postFile_full, array: self.postsArray, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
        }
        else if (postLink != "") {
            cell = GetPostWithLink.sharedInstance.getPostLink(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postLink, array: self.postsArray,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if (postYoutube != "") {
            cell = GetPostYoutube.sharedInstance.getPostYoutub(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postYoutube, array: self.postsArray, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            
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
        else  {
          
            if (self.comments.count == 0 || self.comments.isEmpty == true){
                 let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
                 cell.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
                 cell.noCommentView.isHidden = true
                self.tableView.rowHeight = 230.0
                return cell
            }
            else{
            let index = self.comments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
            cell.noCommentView.isHidden = false
            self.tableView.rowHeight = UITableView.automaticDimension
            cell.imageHeight.constant = 0.0
            cell.imageWidth.isActive = false
            if let publisher = index["publisher"] as? [String:Any]{
                if let name = publisher["username"] as? String{
                    cell.userName.text = name
                }
                
                if let image = publisher["avatar"] as? String{
                    let url = URL(string: image)
                    cell.profileImage.kf.setImage(with: url)
                }
            }
            if let text = index["text"] as? String{
                cell.commentText?.text = text.htmlToString
            }
            if let image = index["c_file"] as? String{
                if image != ""{
                    let img = "\("https://wowonder.fra1.digitaloceanspaces.com/")\(image)"
                    let width = cell.designView.frame.size.width
                    print("Width",width)
                    cell.imageWidth.isActive = true
                    cell.imageWidth.constant = width
                    cell.imageHeight.constant = width
                    let url = URL(string: img)
                    cell.commentImage.kf.setImage(with: url)
                }
                else {
                    cell.imageWidth.isActive = false
                    cell.imageHeight.constant = 0.0
                }
            }
                
                
                if let audioFile = index["record"] as? String{
                    if audioFile != ""{
                        let urlstring = audioFile
                        let url = URL(string: urlstring)
                        print("the url = \(url!)")
                        cell.playBtn.tag = indexPath.row
                        let asset = AVURLAsset(url: URL(fileURLWithPath: audioFile), options: nil)
                        let audioDuration = asset.duration
                        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                        let round = Float(audioDurationSeconds * 60 / 100).rounded()
                        let intRound = Int(round)
                        let str = String(format: "%02d", arguments: [intRound ?? 0])
                        cell.audioTimer.text = "00:\(str)"
                        cell.playBtn.isHidden = false
                        cell.audioTimer.isHidden = false
                        cell.audioViewHeightConstraint.constant = 30.0
                        cell.playBtn.addTarget(self, action: #selector(self.playingAudio(sender:)), for: .touchUpInside)
                    }
                    else{
                        cell.playBtn.isHidden = true
                        cell.audioTimer.isHidden = true
                        cell.audioViewHeightConstraint.constant = 0.0
                    }
                }
                
            //    }
            if let replies = index["replies"] as? String{
                if replies == "0"{
                    cell.replyBtn.setTitle("\("Reply")", for: .normal)
                }
                else {
                    cell.replyBtn.setTitle("\("Reply ")\("(\(replies))")", for: .normal)
                }
            }
//            if let isLiked = index["is_comment_liked"] as? Bool{
//                if isLiked{
//                    cell.likeBtn.setTitle("Liked", for: .normal)
//                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#984243"), for: .normal)
//                }
//            }
                
                
                if let is_react = index["reaction"] as? [String:Any]{
                    if let isLiked = is_react["is_reacted"] as? Bool{
                        if isLiked == true{
                            if let type = is_react["type"] as? String{
                                if type == "1"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Like", comment: "Like"), for: .normal)
                                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                                    cell.reactionImage.image = UIImage(named: "like-2")
                                }
                                else if type == "2"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Love", comment: "Love"), for: .normal)
                                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                                    cell.reactionImage.image = UIImage(named: "love")
                                    
                                }
                                else if type == "3"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Haha", comment: "Haha"), for: .normal)
                                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                    cell.reactionImage.image = UIImage(named: "haha")
                                    
                                }
                                else if type == "4"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Wow", comment: "Wow"), for: .normal)
                                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                    cell.reactionImage.image = UIImage(named: "wow")
                                    
                                }
                                else if type == "5"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Sad", comment: "Sad"), for: .normal)
                                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                    cell.reactionImage.image = UIImage(named: "sad")
                                }
                                else if type == "6"{
                                    cell.likeBtn.setTitle(NSLocalizedString("Angry", comment: "Angry"), for: .normal)
                                    cell.likeBtn.setTitleColor(.red, for: .normal)
                                    cell.reactionImage.image = UIImage(named: "angry")
                                }
                            }
                            
                            
                            if let checkLike = is_react["1"] as? Int{
                                if checkLike != 0{
                                    cell.reactionImage.image = UIImage(named: "like-2")
                                }
                            }
                            if let checkLove = is_react["2"] as? Int{
                                if checkLove != 0{
                                    cell.reactionImage.image = UIImage(named: "love")
                                }
                            }
                            if let checkHaha = is_react["3"] as? Int{
                                if checkHaha != 0{
                                    cell.reactionImage.image = UIImage(named: "haha")
                                }
                            }
                            if let checkWow = is_react["4"] as? Int{
                                if checkWow != 0{
                                    cell.reactionImage.image = UIImage(named: "wow")
                                }
                                
                            }
                            if let checkSad = is_react["5"] as? Int{
                                if checkSad != 0{
                                    cell.reactionImage.image = UIImage(named: "sad")
                                }
                            }
                            if let checkSad = is_react["6"] as? Int{
                                if checkSad != 0{
                                    cell.reactionImage.image = UIImage(named: "angry")
                                }
                            }
                            
                            
                            
                        }
                    }
                    if let count = is_react["count"] as? Int{
                        if count == 0{
                            cell.reactionCount.text = nil
                            cell.reactionImage.image = nil
                            cell.likeBtn.setTitle(NSLocalizedString("Like", comment: "Like"), for: .normal)
                            cell.likeBtn.setTitleColor(.black, for: .normal)
                        }
                        else{
                            cell.reactionCount.text = "\(count)"
                        }
                    }
                }
                
                for i in self.selectedIndexs{
                    if i["index"] as? Int == indexPath.row{
                        if let reaction = i["reaction"] as? String{
                            if reaction == "6"{
                                cell.reactionImage.image = UIImage(named: "angry")
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                                cell.likeBtn.setTitleColor(.red, for: .normal)
                            }
                            else if reaction == "1"{
                                cell.reactionImage.image = UIImage(named: "like-2")
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                            }
                            else if reaction == "2"{
                                cell.reactionImage.image = UIImage(named: "love")
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                            }
                            else if reaction == "4"{
                                cell.reactionImage.image = UIImage(named: "wow")
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                            }
                            else if reaction == "5"{
                                cell.reactionImage.image = UIImage(named: "sad")
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                            }
                            else if reaction == "3"{
                                cell.reactionImage.image = UIImage(named: "haha")
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                            }
                            else if reaction == ""{
        //                        cell.likeBtn.setTitleColor(.lightGray, for: .normal)
        //                        cell.likeBtn.setImage(UIImage(named:"like"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                            }
                        }
                        if let count = i["count"] as? Int{
                            cell.reactionCount.text = "\(count)"
                        }
                    }
                }
                let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
                normalTapGesture.numberOfTapsRequired = 1
                longGesture.minimumPressDuration = 0.30
                
                cell.likeBtn.addGestureRecognizer(normalTapGesture)
                cell.likeBtn.addGestureRecognizer(longGesture)
                cell.replyBtn.tag = indexPath.row
                cell.likeBtn.tag = indexPath.row
                cell.reactionBtn.tag = indexPath.row
                cell.replyBtn.addTarget(self, action: #selector(self.GotoCommentReply(sender:)), for: .touchUpInside)
                cell.reactionBtn.addTarget(self, action: #selector(self.GotoPostReaction(sender:)), for: .touchUpInside)
                cell.viewLeadingContraint.constant = 8.0
                
//            cell.replyBtn.tag = indexPath.row
//            cell.likeBtn.tag = indexPath.row
//            cell.replyBtn.addTarget(self, action: #selector(self.GotoCommentReply(sender:)), for: .touchUpInside)
//            cell.likeBtn.addTarget(self, action: #selector(self.LikeComment(sender:)), for: .touchUpInside)
//            cell.viewLeadingContraint.constant = 8.0
            return cell
            }
        }
    }
    
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        self.selectedIndex = gesture.view!.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            let cell = self.tableView.cellForRow(at: IndexPath(row: gesture.view?.tag ?? 0, section: 7)) as! CommentCellTableViewCell
            if let reactions = self.comments[gesture.view?.tag ?? 0]["reaction"] as? [String:Any]{
                var totalCount = 0
                if let count = reactions["count"] as? Int{
                    totalCount = count
                }
                if let isReacted = reactions["is_reacted"] as? Bool{
                    if (isReacted == true){
                        self.reactions(index: gesture.view?.tag ?? 0, reaction: "")
                        var localPostArray = self.comments[gesture.view?.tag ?? 0]["reaction"] as! [String:Any]
                        localPostArray["is_reacted"] = false
                        localPostArray["type"]  = ""
                        localPostArray["count"] = totalCount - 1
                        totalCount =  localPostArray["count"] as? Int ?? 0
                        if totalCount == 0{
                            cell.reactionImage.image = nil
                            cell.reactionCount.text = nil
                        }
                        if let reaction_type = reactions["type"] as? String{
                            if reaction_type == "1"{
                                if let likecount = reactions["1"] as? Int{
                                    localPostArray["1"] = likecount - 1
                                }
                            }
                            else if reaction_type == "2"{
                                if let lovecount = reactions["2"] as? Int{
                                    localPostArray["2"] = lovecount - 1
                                }
                            }
                            else if reaction_type == "3"{
                                if let hahacount = reactions["3"] as? Int{
                                    localPostArray["3"] = hahacount - 1
                                }
                            }
                            else if reaction_type == "4"{
                                if let wowcount = reactions["4"] as? Int{
                                    localPostArray["4"] = wowcount - 1
                                }
                            }
                            else if reaction_type == "5"{
                                if let sadcount = reactions["5"] as? Int{
                                    localPostArray["5"] = sadcount - 1
                                }
                            }
                            else if reaction_type == "6"{
                                if let angryCount = reactions["6"] as? Int{
                                    localPostArray["6"] = angryCount - 1
                                }
                            }
                            
                        }
                        self.comments[gesture.view?.tag ?? 0]["reaction"] = localPostArray
                        cell.likeBtn.setTitle(NSLocalizedString("Like", comment: "Like"), for: .normal)
                        cell.likeBtn.setTitleColor(.black, for: .normal)
                        cell.reactionCount.text = "\(totalCount)"
                        if totalCount != 0{
                        if let reacts = self.comments[gesture.view?.tag ?? 0]["reaction"] as? [String:Any]{
                            if let checkLike = reacts["1"] as? Int{
                                if checkLike != 0{
                                    cell.reactionImage.image = UIImage(named: "like-2")
                                    break;
                                }
                            }
                            if let checkLove = reacts["2"] as? Int{
                                if checkLove != 0{
                                    cell.reactionImage.image = UIImage(named: "love")
                                    break;
                                }
                            }
                            if let checkHaha = reacts["3"] as? Int{
                                if checkHaha != 0{
                                    cell.reactionImage.image = UIImage(named: "haha")
                                    break;
                                }
                            }
                            if let checkWow = reacts["4"] as? Int{
                                if checkWow != 0{
                                    cell.reactionImage.image = UIImage(named: "wow")
                                    break;
                                }
                                
                            }
                            if let checkSad = reacts["5"] as? Int{
                                if checkSad != 0{
                                    cell.reactionImage.image = UIImage(named: "sad")
                                    break;
                                }
                            }
                            if let checkSad = reacts["6"] as? Int{
                                if checkSad != 0{
                                    cell.reactionImage.image = UIImage(named: "angry")
                                    break;
                                }
                            }
                        }
                      }
                        else{
                            cell.reactionImage.image = nil
                            cell.reactionCount.text = nil
                        }
                    }
                    else{
                        self.selectedIndex = gesture.view!.tag
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
                        vc.delegate = self
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    
    private func reactions(index :Int, reaction: String) {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                var comment_id = ""
                if let commentId = self.comments[index]["id"] as? String{
                    comment_id = commentId
                }
                AddCommentReactionManager.sharedInstacne.AddComment(commentId: Int(comment_id) ?? 0, reaction: reaction) { (success, authError, error) in
                    if (success != nil){
                        print(success?.message)
                    }
                    else if (authError != nil){
                        print(authError?.errors?.errorText)
                    }
                    else if (error != nil){
                        print(error?.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    func addReaction(reation: String) {
        print(reation)
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedIndex ?? 0, section: 7)) as! CommentCellTableViewCell
        print(self.selectedIndex)
        self.reactions(index: self.selectedIndex, reaction: reation)
        var localPostArray = self.comments[self.selectedIndex]["reaction"] as! [String:Any]
        var totalCount = 0
        if let reactions = self.comments[self.selectedIndex]["reaction"] as? [String:Any]{
            if let is_react = reactions["is_reacted"] as? Bool{
                if !is_react {
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                    localPostArray["count"] = totalCount + 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                    print(totalCount)
                    cell.reactionCount.text = "\(totalCount)"
                }
                else{
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                }
            }
        }
        let action = ["count": totalCount, "reaction": reation,"index": self.selectedIndex] as [String : Any]
        var count = 0
        print(self.selectedIndexs.count)
        if self.selectedIndexs.count == 0 {
            self.selectedIndexs.append(action)
        }
        else{
            for i in self.selectedIndexs{
                count += 1
                if i["index"] as? Int == self.selectedIndex{
                    print((count) - 1)
                    self.selectedIndexs[(count) - 1] = action
                }
                else{
                    self.selectedIndexs.append(action)
                }
            }
        }
        
        localPostArray["is_reacted"] = true
        localPostArray["type"]  = reation
        
        if reation == "1"{
            localPostArray["Like"] = 1
            localPostArray["1"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "like-2")
            cell.likeBtn.setTitle("\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            localPostArray["Love"] = 1
            localPostArray["2"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.likeBtn.setTitle("\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
            cell.reactionImage.image = UIImage(named: "love")
        }
        else if reation == "3"{
            localPostArray["HaHa"] = 1
            localPostArray["3"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "haha")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
        }
        else if reation == "4"{
            localPostArray["Wow"] = 1
            localPostArray["4"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "wow")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
        }
        else if reation == "5"{
            localPostArray["Sad"] = 1
            localPostArray["5"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "sad")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
        }
        else {
            localPostArray["Angry"] = 1
            localPostArray["6"] = 1
            self.comments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "angry")
            cell.likeBtn.setTitle("\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
            cell.likeBtn.setTitleColor(.red, for: .normal)
        }
        
    }
    
    
    @IBAction func GotoPostReaction(sender :UIButton){
        if let reaction = self.comments[sender.tag]["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                if count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PostReactionVC") as! PostReactionController
                    if let postId = self.comments[sender.tag]["id"] as? String{
                        print(postId)
                        vc.postId = postId
                    }
                    if let reactions = self.comments[sender.tag]["reaction"] as? [String:Any]{
                        vc.reaction = reactions
                    }
                    vc.is_Comment = 1
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func GotoCommentReply(sender: UIButton){
        let vc = Storyboard.instantiateViewController(withIdentifier : "CommentReplyVC") as! CommentReplyController
        vc.comment = self.comments[sender.tag]
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func LikeComment(sender: UIButton){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as! CommentCellTableViewCell
            var commentId :String? = nil
            if let id = self.comments[sender.tag]["id"] as? String{
                commentId = id
            }
            if let isLiked = self.comments[sender.tag]["is_comment_liked"] as? Bool{
                if isLiked{
                    cell.likeBtn.setTitle("Like", for: .normal)
                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#333333"), for: .normal)
                    self.likeComment(commentId: commentId ?? "", type: "comment_dislike")
                }
                else {
                    cell.likeBtn.setTitle("Liked", for: .normal)
                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                    self.likeComment(commentId: commentId ?? "", type: "comment_like")
                }
            }
        }
    }
}
