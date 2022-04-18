

import UIKit
import ImageSlideshow
import Kingfisher
import WoWonderTimelineSDK
import AlamofireImage
import Toast_Swift
import AVFoundation


class ProductDetailController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    let screenHeight = UIScreen.main.bounds.height
    var productDetails = [String:Any]()
    var comments = [[String:Any]]()
    var postData = [String:Any]()
    var offset = ""
    var postId: String? = nil
    var userId = ""
    var player = AVAudioPlayer()
    var counter = 0
    var timer = Timer()
    var audioIndex = 0
    
    let status = Reach().connectionStatus()
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
       self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tableView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "productDetailCell")
        self.tableView.register(UINib(nibName: "CommentCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        self.tableView.register(UINib(nibName: "LikeAndCommentCell", bundle: nil), forCellReuseIdentifier: "LikeCommentCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = .none
        self.contentViewHeight.constant = self.screenHeight + 265.0
        if let post_Id = self.productDetails["post_id"] as? String{
            self.postId = post_Id
        }
        self.getPostdata()
        self.getComments()
    }
    
    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
//                let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var imagess = [KingfisherSource]()
//        for i in (self.productDetails["images"] as? [[String:Any]])!{
//            images.append(KingfisherSource(urlString: i["image"] as? String ?? "")!)
//        }
        if let images = self.productDetails as? [String:Any]{
            if let image = images["images"] as? [[String:Any]]{
                for i in image{
                    imagess.append(KingfisherSource(urlString: i["image"] as? String ?? "")!)
                }
            }
        }
        
        self.imageSlider.contentMode = .scaleAspectFill
        self.imageSlider.contentScaleMode = .scaleToFill
        self.imageSlider.setImageInputs(imagess)
        
        self.tableView.reloadData()
    }
    
    
    private func getComments(){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                FetchCommentManager.sharedInstance.fetchComment(postId: self.postId ?? "12" , offset: self.offset) { (success, authError, error) in
                    if success != nil {
                        self.comments.removeAll()
                        for i in success!.data {
                            self.comments.append(i)
                        }
                        //                        if (self.comments.isEmpty == true){
                        //                            self.tableView.isHidden = true
                        //                            //                            self.noCommentView.isHidden = false
                        //                        }
                        self.tableView.reloadData()
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
    
    private func getPostdata(){
        GetPostByIdManager.sharedInstance.getPost(post_id: self.postId ?? "10") { (success, authError, error) in
            if (success != nil){
                self.postData = success!.post_data
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
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func timerAction(){
        let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 2)) as! CommentCellTableViewCell
        counter += 1
        let str = String(format: "%02d", arguments: [counter ?? 0])
        cell.audioTimer.text = "00:\(str)"
//        cell.audioTimer.text = "00:\(counter)"
    }
    
    @objc func playingAudio(sender:UIButton){
        if self.player.isPlaying == true{
            self.timer.invalidate()
            self.counter = 0
            self.player.stop()
            let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 2)) as! CommentCellTableViewCell
            cell.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else{
        self.timer.invalidate()
        self.counter = 0
        self.audioIndex = sender.tag
        self.player.stop()
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! CommentCellTableViewCell
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
    
}
extension ProductDetailController :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 1
        }
        else if (section == 2){
            return 1
        }
        else {
            if (self.comments.count == 0 || self.comments.isEmpty == true){
                return 1
            }
            else{
                return 0
//                    self.comments.count
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }
        else if indexPath.section == 1{
            return  80.0
        }
        else if indexPath.section == 2{
            return  55.0
        }

        else {
            if self.comments.count == 0{
                return 230.0
            }
            else{
                return UITableView.automaticDimension
            }
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell") as! ProductDetailCell
            
            if let description = self.productDetails["description"] as? String{
                cell.descriptionLabel.text! = description.htmlToString
            }
            if let location = self.productDetails["location"] as? String{
                cell.locationLabel.text! = location
            }
            if let price =  self.productDetails["price"] as? String{
                cell.productPrice.text! = "\(price)\(" ")\("$")"
            }
            cell.moreBtn.addTarget(self, action: #selector(self.More(sender:)), for: .touchUpInside)
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserContactcell") as! UserContactCell
            var names = ""
            var isPro = ""
            var isVerified = ""
            if let seller = self.productDetails["seller"] as? [String:Any]{
                if let image = seller["avatar"] as? String{
                    let url = URL(string: image)
                    cell.userImage.kf.setImage(with: url)
                }
                if let name = seller["name"] as? String{
                   names = name
                }
                if let userID = seller["user_id"] as? String{
                    self.userId = userID
                }
                if let postedTime = seller["time_text"] as? String{
                    cell.postedLabel.text! = postedTime
                }
                if let sellerId = seller["user_id"] as? String{
                    if sellerId == UserData.getUSER_ID()!{
                        cell.contatBtn.isHidden = true
                    }
                    else{
                        cell.contatBtn.isHidden = false
                    }
                }
                if let is_pro = seller["is_pro"] as? String{
                    isPro = is_pro
                }
                if let is_verify = seller["verified"] as? String{
                    isVerified = is_verify
                }
            }
            

            let imageAttachment =  NSTextAttachment()
            let imageAttachment1 =  NSTextAttachment()
            imageAttachment.image = UIImage(named:"veirfied")
            imageAttachment1.image = UIImage(named: "flash-1")
            let imageOffsetY: CGFloat = -2.0
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            imageAttachment1.bounds = CGRect(x: 0, y: imageOffsetY, width: 11.0, height: 14.0)
            let attechmentString = NSAttributedString(attachment: imageAttachment)
            let attechmentString1 = NSAttributedString(attachment: imageAttachment1)
            let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString1 = NSMutableAttributedString(string: names, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: " ", attributes:attrs2)
            let attributedString3 = NSMutableAttributedString(attributedString: attechmentString)
            let attributedString4 = NSMutableAttributedString(string: " ", attributes:attrs2)
            let attributedString5 = NSMutableAttributedString(attributedString: attechmentString1)
            attributedString1.append(attributedString2)
            if (isVerified == "1") && (isPro == "1"){
                attributedString1.append(attributedString3)
                attributedString1.append(attributedString4)
                attributedString1.append(attributedString5)
            }
            else if (isVerified == "1"){
                attributedString1.append(attributedString3)
                attributedString1.append(attributedString4)
            }
            else if (isPro == "1"){
                attributedString1.append(attributedString5)
            }
            cell.username.attributedText = attributedString1
            
        cell.contatBtn.addTarget(self, action: #selector(self.gotoMessengerApp(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCommentCell") as! LikeAndCommentCell
            cell.bind(data: self.postData)
            cell.vc = self
            cell.post_id = self.postId ?? "0"
            if let reactions = self.productDetails["reaction"] as? [String:Any]{
                if let count = reactions["count"] as? Int{
//                    cell.likesCountBtn.setTitle("\(count)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
                }
                if let isreact  = reactions["is_reacted"] as? Bool {
                    if isreact == true{
                        if let type = reactions["type"] as? String{
                            if type == "6"{
                                cell.likeBtn.setImage(UIImage(named: "angry"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                                cell.likeBtn.setTitleColor(.red, for: .normal)
                            }
                            else if type == "1"{
                                cell.likeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                            }
                            else if type == "2"{
                                cell.likeBtn.setImage(UIImage(named: "love"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                            }
                            else if type == "4"{
                                cell.likeBtn.setImage(UIImage(named: "wow"), for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                            }
                            else if type == "5"{
                                cell.likeBtn.setImage(UIImage(named: "sad"), for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                            }
                            else if type == "3"{
                                cell.likeBtn.setImage(UIImage(named: "haha"), for: .normal)
                                cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                                cell.likeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                            }
                        }
                    }
                    else{
                        cell.likeBtn.setTitleColor(.lightGray, for: .normal)
                        cell.likeBtn.setImage(UIImage(named:"like"), for: .normal)
                        cell.likeBtn.setTitle("\("       ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    }
                }
            }
            return cell
        }
    
        else  {
            

            if self.comments.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
                cell.noCommentView.isHidden = true
                return cell
            }
            else{
                let index = self.comments[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
            cell.noCommentView.isHidden = false
            cell.imageHeight.constant = 0.0
            cell.imageWidth.isActive = false
            //        cell.imageWidth.constant = 100.0
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
            if let replies = index["replies"] as? String{
                if replies == "0"{
                    cell.replyBtn.setTitle("\("Reply")", for: .normal)
                }
                else {
                    cell.replyBtn.setTitle("\("Reply ")\("(\(replies))")", for: .normal)
                }
            }
            if let isLiked = index["is_comment_liked"] as? Bool{
                if isLiked{
                    cell.likeBtn.setTitle("Liked", for: .normal)
                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                }
            }
            cell.replyBtn.tag = indexPath.row
            cell.likeBtn.tag = indexPath.row
            cell.replyBtn.addTarget(self, action: #selector(self.GotoCommentReply(sender:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(self.LikeComment(sender:)), for: .touchUpInside)
            cell.viewLeadingContraint.constant = 8.0
            return cell
            }
        }
    }
    
    @IBAction func gotoMessengerApp(sender: UIButton){

        let appURLScheme = "AppToOpen://userId=\(self.userId)"
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
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! CommentCellTableViewCell
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
    
    @IBAction func More(sender: UIButton){
        var Url: String? = nil
        if let url =  self.productDetails["url"] as? String{
            Url = url
        }
        let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default, handler: { (_) in
            UIPasteboard.general.string = Url ?? ""
            self.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Share", comment: "Share"), style: .default, handler: { (_) in
            // text to share
            let text = Url ?? ""
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional,)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
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
    
}
