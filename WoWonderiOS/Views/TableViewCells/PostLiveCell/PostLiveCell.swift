//
//  PostLiveCell.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/20/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import AVFoundation
import ActiveLabel

class PostLiveCell: UITableViewCell,AddReactionDelegate,SharePostDelegate,comment_CountsDelegate {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeAndcommentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var commentsCountBtn: UIButton!
    @IBOutlet weak var likeandcommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet var streamStatusLbl: UILabel!
    @IBOutlet var gotoStreamBtn: UIButton!
    @IBOutlet var textsLabel: ActiveLabel!
    @IBOutlet var liveLabel: RoundLabel!
    
    var vc: UIViewController?
    var indexPath = 0
    var selectedIndex = 0
    var commentsIndex = [[String:Any]]()
    var comment_count = "0"
    var data = [String:Any]()
    var selectedIndexs = [[String:Any]]()
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "button", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var is_live = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
        self.commentBtn.setTitle("\(" ")\(NSLocalizedString("Comment", comment: "Comment"))", for: .normal)
        self.shareBtn.setTitle("\(" ")\(NSLocalizedString("Share", comment: "Share"))", for: .normal)
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)
        
        let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
        normalTapGesture.numberOfTapsRequired = 1
        longGesture.minimumPressDuration = 0.30
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        
        self.LikeBtn.addGestureRecognizer(normalTapGesture)
        self.LikeBtn.addGestureRecognizer(longGesture)
        self.profileImage.addGestureRecognizer(gesture)
        self.profileImage.isUserInteractionEnabled = true
        self.profileName.isUserInteractionEnabled = true
        self.profileName.addGestureRecognizer(gestureonLabel)

    }
    

    func bind(index:[String:Any],indexPath:Int){
        self.data = index
        self.indexPath = indexPath
        var postTypes = ""
        var names = ""
        var fileURL = ""
        var isPro = ""
        var isVerified = ""
        
        if let time = index["post_time"] as? String{
            self.timeLabel.text! = time
        }
        
        if let text = index["postText"] as? String{
            self.textsLabel.text = text.htmlToString
        }
        

        if let publisher = index["publisher"] as? [String:Any] {
            if let profilename = publisher["name"] as? String{
                print(profilename)
                names = profilename
            }
            if let avatarUrl =  publisher["avatar"] as? String {
                let url = URL(string: avatarUrl)
                self.profileImage.kf.setImage(with: url)
            }
            if let is_pro = publisher["is_pro"] as? String{
                isPro = is_pro
            }
            if let is_verify = publisher["verified"] as? String{
                isVerified = is_verify
            }
        }
        
        if let isLive = index["is_still_live"] as? Bool {
            if isLive == true {
                self.is_live = true
                postTypes = NSLocalizedString("is live now", comment: "is live now")
                self.streamStatusLbl.text = "\(names)\(" ")\(NSLocalizedString("started broadcasting live.", comment: "started broadcasting live."))"
            }
            else {
                self.is_live = false
                postTypes = NSLocalizedString("was live", comment: "was live")
                self.streamStatusLbl.text = "\(names)\(" ")\(NSLocalizedString("stream has ended.", comment: "stream has ended."))"
            }
        }
        
        if let reactions = index["reaction"] as? [String:Any]{
            if let count = reactions["count"] as? Int{
                self.likesCountBtn.setTitle("\(count)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
            }
            if let isreact  = reactions["is_reacted"] as? Bool {
                if isreact == true{
                    if let type = reactions["type"] as? String{
                        if type == "6"{
                            self.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                            self.LikeBtn.setTitleColor(.red, for: .normal)
                        }
                        else if type == "1"{
                            self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                        }
                        else if type == "2"{
                            self.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                        }
                        else if type == "4"{
                            self.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                        }
                        else if type == "5"{
                            self.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                        }
                        else if type == "3"{
                            self.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                        }
                    }
                }
                else{
                    self.LikeBtn.setTitleColor(.lightGray, for: .normal)
                    self.LikeBtn.setImage(UIImage(named:"like"), for: .normal)
                    self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                }
            }
        }
    
        if let commentsCount = index["post_comments"] as? String{
            self.commentsCountBtn.setTitle("\(NSLocalizedString("Comments", comment: "Comments"))\(" ")\(commentsCount)", for: .normal)
        }
        
        for i in self.commentsIndex{
            if i["index"] as? Int == self.indexPath{
                self.commentsCountBtn.setTitle("\(NSLocalizedString("Comments", comment: "Comments"))\(" ")\(i["count"] ?? "")", for: .normal)
            }
        }

        
        
        for i in self.selectedIndexs{
            if i["index"] as? Int == self.indexPath{
                if let reaction = i["reaction"] as? String{
                    if reaction == "6"{
                        self.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                        self.LikeBtn.setTitleColor(.red, for: .normal)
                    }
                    else if reaction == "1"{
                        self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)

                    }
                    else if reaction == "2"{
                        self.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                    }
                    else if reaction == "4"{
                        self.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                    }
                    else if reaction == "5"{
                        self.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                    }
                    else if reaction == "3"{
                        self.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                    }
                        
                    else if reaction == ""{
                        self.LikeBtn.setTitleColor(.lightGray, for: .normal)
                        self.LikeBtn.setImage(UIImage(named:"like"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    }
                }
                if let count = i["count"] as? Int{
                    self.likesCountBtn.setTitle("\(count)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
                }
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
        let attrs3 = [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string: names, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(attributedString: attechmentString)
        let attributedString4 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString5 = NSMutableAttributedString(attributedString: attechmentString1)
        let attributedString6 = NSMutableAttributedString(string: "\(" ")\(postTypes)", attributes:attrs3)
        
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
        attributedString1.append(attributedString6)
        self.profileName.attributedText = attributedString1
    }
    
    private func reactions(index :Int, reaction: String) {
        performUIUpdatesOnMain {
            var postID = ""
            if let postId = self.data["post_id"] as? String{
                postID = postId
            }
            AddReactionManager.sharedInstance.addReaction(postId: postID, reaction: reaction) { (success, authError, error) in
                if success != nil{
                    print(success?.action)
                }
                else if authError != nil{
                    print(authError?.errors.errorText)
                }
                else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func GotoStream(_ sender: Any) {
        if (self.is_live == true){
            let vcs = Storyboard.instantiateViewController(withIdentifier: "LiveVC") as! LiveStreamController
            vcs.isJoin = 1
            if let postId = self.data["post_id"] as? String{
                vcs.post_id = postId
            }
            if let streamName = self.data["stream_name"] as? String{
                vcs.streamName = streamName
            }
            if let publisher = self.data["publisher"] as? [String:Any] {
                if let avatarUrl =  publisher["avatar"] as? String {
                    vcs.userImages = avatarUrl
//                    let url = URL(string: avatarUrl)
//                    self.profileImage.kf.setImage(with: url)
                }
            }
            
            
            vcs.modalTransitionStyle = .coverVertical
            vcs.modalPresentationStyle = .fullScreen
            self.vc?.present(vcs, animated: true, completion: nil)
        }
        else{
            print("Nothing")
        }

    }
    
    @IBAction func Like(_ sender: Any) {
    }
    
    @IBAction func Comment(_ sender: Any) {
        let vc = Storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentController
        if let postId = self.data["post_id"] as? String{
            vc.postId = postId
        }
        if let status = self.data["comments_status"] as? String{
            vc.commentStatus = status
        }
        if let reaction = self.data["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                vc.likes = count
            }
        }
        if let comments = self.data["get_post_comments"] as? [[String:Any]]{
            print(comments)
//            vc.comments = comments
        }
        if let counts = self.data["post_comments"] as? String{
            self.comment_count = counts
        }
        self.selectedIndex = indexPath
        vc.deleagte = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func Share(_ sender: Any) {
        self.selectedIndex = indexPath
        let vc = Storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.vc?.present(vc, animated: true, completion: nil)
    }
    

    @IBAction func More(_ sender: Any) {
        var post_id: String? = nil
        if let postId = self.data["post_id"] as? String{
            post_id = postId
        }
        let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        if let is_saved = self.data["is_post_saved"] as? Bool{
            if !is_saved{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Save Post", comment: "Save Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.data["is_post_saved"] = true
                        SavePostManager.sharedInstance.savedPost(targetController: self.vc!, postId: post_id ?? "", action: "save")
                    }
                }))
            }
            else{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Unsave Post", comment: "Unsave Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.data["is_post_saved"] = false
                        SavePostManager.sharedInstance.savedPost(targetController: self.vc!, postId: post_id ?? "", action: "save")
                    }
                }))
            }
        }
        
        if let copyText = self.data["postText"] as? String{
            if copyText != ""{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Text", comment: "Copy Text"), style: .default, handler: { (_) in
                    UIPasteboard.general.string = copyText
                    self.vc?.view.makeToast(NSLocalizedString("Text copied to clipboard", comment: "Text copied to clipboard"))
                }))
            }
        }
        
        if let copyLink = self.data["url"] as? String{
            alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Link", comment: "Copy Link"), style: .default, handler: { (_) in
                UIPasteboard.general.string = copyLink
                self.vc?.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
            }))
        }
        
        
        if let publisher = self.data["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost != UserData.getUSER_ID() || is_myPost == UserData.getUSER_ID(){
                    if let is_report = self.data["is_post_reported"] as? Bool{
                        if !is_report{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Report Post", comment: "Report Post"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                        ReportPostManager.sharedInstance.reportedPost(targetController: self.vc!, postId: post_id ?? "")
                                }
                            }))
                        }
                    }
                }
            }
        }
        
        
        if let publisher = self.data["publisher"] as? [String:Any]{
                if let is_myPost = publisher["user_id"] as? String{
                    if (is_myPost == UserData.getUSER_ID()) {
                        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Boost Post", comment: "Boost Post"))", style: .default, handler: { (_) in
                            let status = Reach().connectionStatus()
                            switch status {
                            case .unknown, .offline:
                                self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                            case .online(.wwan), .online(.wiFi):
                                BoostPostManager.sharedInstance.boostPosts(targetController: self.vc!, postId: post_id ?? "")
                            }
                        }))
                    }
                }
            }
        
        
        if let publisher = self.data["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    var postId = ""
                    var text = ""
                    var privacy = ""
                    if let postid = self.data["post_id"] as? String{
                        postId = postid
                    }
                    if let texts = self.data["postText"] as? String{
                        text = texts
                    }
                    if let privacyi = self.data["postPrivacy"] as? String{
                        privacy = privacyi
                    }
                alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Edit Post", comment: "Edit Post"))", style: .default, handler: { (_) in
                        if AppInstance.instance.vc == "myProfile"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "newsFeedVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "popularPostVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "hasTagPostVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "savedPostVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "showPostVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "eventDetailVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "pageVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "groupVC"{
                            let userInfo = ["userData":self.indexPath,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                    }))
                }
            }
        }
        
        
        if let publisher = self.data["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    if let enableComment = self.data["comments_status"] as? String{
                        let post_Id = Int(post_id ?? "")
                        if enableComment == "1"{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Disable Comments", comment: "Disable Comments"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    self.data["comments_status"] = "0"
                                    CommentDisableManager.sharedIntsance.disableComment(targetController: self.vc!, postId: post_Id ?? 0)
                                }
                            }))
                        }
                        else{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Enable Comments", comment: "Enable Comments"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    self.data["comments_status"] = "1"
                                    CommentDisableManager.sharedIntsance.disableComment(targetController: self.vc!, postId: post_Id ?? 0)
                                }
                            }))
                            
                        }
                    }
                }
            }
        }
        
        if let publisher = self.data["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    //                alert.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                    //                }))
                    //                alert.addAction(UIAlertAction(title: "Boost Post", style: .default, handler: { (_) in
                    //                }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .default, handler: { (_) in
                        DeletePostManager.sharedInstance.postDelete(targetController: self.vc!,   postId: post_id ?? "") { (success) in
                            if AppInstance.instance.vc == "myProfile"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "newsFeedVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "popularPostVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "hasTagPostVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "savedPostVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "showPostVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "eventDetailVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "pageVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "groupVC"{
                                let userInfo = ["userData":self.indexPath,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                        }
                    }))
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.vc?.view
            popoverController.sourceRect = CGRect(x: self.vc!.view.bounds.midX, y: self.vc!.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.vc?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
//            let cell =  self.vc?.view.cellForRow(at: IndexPath(row: gesture.view!.tag, section: 6)) as! NormalPostCell
            self.audioPlayer.play()
            if let reactions = self.data["reaction"] as? [String:Any]{
                var totalCount = 0
                if let count = reactions["count"] as? Int{
                    totalCount = count
                }
                if let is_react = reactions["is_reacted"] as? Bool{
                    if is_react == true{
                        self.reactions(index: gesture.view!.tag, reaction: "")
                        var localPostArray = self.data["reaction"] as! [String:Any]
                        localPostArray["is_reacted"] = false
                        localPostArray["type"]  = ""
                        localPostArray["count"] = totalCount - 1
                        totalCount =  localPostArray["count"] as? Int ?? 0
                        self.data["reaction"] = localPostArray
                        self.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
                        self.LikeBtn.setImage(UIImage(named: "like"), for: .normal)
                        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        self.LikeBtn.setTitleColor(.lightGray, for: .normal)
                        let action = ["count": totalCount, "reaction": "","index":gesture.view?.tag ?? 0] as [String : Any]
                        var count = 0
                        if self.selectedIndexs.count == 0{
                            self.selectedIndexs.append(action)
                        }
                        else{
                            for i in self.selectedIndexs{
                                count += 1
                                if i["index"] as? Int == gesture.view?.tag{
                                    print((count) - 1)
                                    self.selectedIndexs[(count) - 1] = action
                                }
                                else{
                                    self.selectedIndexs.append(action)
                                }
                            }
                        }
                    }
                    else{
                        var localPostArray = self.data["reaction"] as! [String:Any]
                        localPostArray["is_reacted"] = true
                        localPostArray["type"]  = "Like"
                        localPostArray["count"] = totalCount + 1
                        localPostArray["Like"] = 1
                        totalCount =  localPostArray["count"] as? Int ?? 0
                        self.data["reaction"] = localPostArray
                        self.reactions(index: gesture.view!.tag, reaction: "1")
                        self.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
                        self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                        self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                        let action = ["count": totalCount, "reaction": "1","index":gesture.view?.tag ?? 0] as [String : Any]
                        var count = 0
                        print(self.selectedIndexs.count)
                        if self.selectedIndexs.count == 0 {
                            self.selectedIndexs.append(action)
                        }
                        else{
                            for i in self.selectedIndexs{
                                count += 1
                                if i["index"] as? Int == gesture.view?.tag{
                                    print((count ?? 0) - 1)
                                    self.selectedIndexs[(count ?? 0) - 1] = action
                                }
                                else{
                                    self.selectedIndexs.append(action)
                                }
                            }
                        }
                    }
                }
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
        self.vc?.present(vc, animated: true, completion: nil)
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addReaction(reation: String) {
//        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedIndex, section: 6)) as! NormalPostCell
        self.audioPlayer.play()
        self.reactions(index: self.indexPath, reaction: reation)
        var localPostArray = self.data["reaction"] as! [String:Any]
        var totalCount = 0
        if let reactions = self.data["reaction"] as? [String:Any]{
            if let is_react = reactions["is_reacted"] as? Bool{
                if !is_react {
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                    localPostArray["count"] = totalCount + 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                    self.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
                }
                else{
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                }
            }
        }
        
        let action = ["count": totalCount, "reaction": reation,"index": self.indexPath] as [String : Any]
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
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            localPostArray["Love"] = 1
            localPostArray["2"] = 1
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
        }
        else if reation == "3"{
            localPostArray["HaHa"] = 1
            localPostArray["3"] = 1
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
        }
        else if reation == "4"{
            localPostArray["Wow"] = 1
            localPostArray["4"] = 1
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
        }
        else if reation == "5"{
            localPostArray["Sad"] = 1
            localPostArray["5"] = 1
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
        }
        else {
            localPostArray["Angry"] = 1
            localPostArray["6"] = 1
            self.data["reaction"] = localPostArray
            self.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
            self.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
            self.LikeBtn.setTitleColor(.red, for: .normal)
        }
    }
    
    @IBAction func gotoUserProfile(gesture: UIGestureRecognizer){
        
      
//            var groupId: String? = nil
//            var pageId: String? = nil
//            var user_data: [String:Any]? = nil
             if let data = self.data["publisher"] as? [String:Any]{
                if let is_myPost = data["user_id"] as? String{
                    if is_myPost != UserData.getUSER_ID(){
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
                        vc.userData = data
                        self.vc?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if (is_myPost == UserData.getUSER_ID()){
                        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileController
                        self.vc?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
    }
    
    @IBAction func LikeCounts(_ sender: Any) {
        if let reaction = self.data["reaction"] as? [String:Any]{
                if let count = reaction["count"] as? Int{
                    if count > 0 {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "PostReactionVC") as! PostReactionController
                        if let postId = self.data["post_id"] as? String{
                            vc.postId = postId
                        }
                        if let reactions = self.data["reaction"] as? [String:Any]{
                            vc.reaction = reactions
                        }
                        self.vc?.present(vc, animated: true, completion: nil)
                    }
                }
            }
    }
}


extension PostLiveCell{
    
    func sharePost() {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts = [self.data]
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    func sharePostTo(type: String) {
        if (type == "group") || (type == "page"){
            let Storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier : "MyGroups&PagesVC") as! MyGroupsandMyPagesController
            vc.type = type
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.vc?.present(vc, animated: true, completion: nil)
    }
        else {
            let vc = Storyboard.instantiateViewController(withIdentifier : "SharePopUpVC") as! SharePopUpController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.vc?.present(vc, animated: true, completion: nil)
        }
}
    
    func sharePostLink() {
        // text to share
        var text = ""
        if let postUrl =  self.data["url"] as? String{
            text = postUrl
        }
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.vc?.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional,)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
        
        // present the view controller
        self.vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    func selectPageandGroup(data: [String : Any], type: String) {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts = [self.data]
        if type == "group"{
            if let groupName = data["group_name"] as? String{
                vc.groupName = groupName
            }
            if let groupId = data["id"] as? String{
                vc.groupId = groupId
            }
            if let image  = data["avatar"] as? String{
                let trimmedString = image.trimmingCharacters(in: .whitespaces)
                vc.imageUrl = trimmedString
            }
            vc.isGroup = true
        }
        else {
            if let pageName = data["page_title"] as? String{
                vc.pageName = pageName
            }
            if let pageId = data["id"] as? String{
                vc.pageId = pageId
            }
            if let image  = data["avatar"] as? String{
                vc.imageUrl = image
            }
            vc.isPage = true
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    func comment_Count() {
//        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedIndex, section: 6)) as! NormalPostCell
            
            let count = Int(self.comment_count) ?? 0
            let total = count + 1
            self.commentsCountBtn.setTitle("\(NSLocalizedString("Comments", comment: "Comments"))\(" ")\(total)", for: .normal)
            self.data["post_comments"] = "\(total)"
           print(self.data["post_comments"])
            var commentCount = 0
            let action = ["count": total,"index": self.selectedIndex] as [String : Any]
            print(self.commentsIndex.count)
            if self.commentsIndex.count == 0 {
                self.commentsIndex.append(action)
            }
          
            else{
                for i in self.commentsIndex{
                    commentCount += 1
                    if i["index"] as? Int == self.selectedIndex{
                        let count = i["count"] ?? 0
                        self.commentsIndex[commentCount - 1]["count"] = count as! Int + 1
                    }
                    else{
                        self.commentsIndex.append(action)
                    }
                }
            }
    }
    
}
