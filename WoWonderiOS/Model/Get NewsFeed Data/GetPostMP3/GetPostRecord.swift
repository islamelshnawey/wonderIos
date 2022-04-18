

import Foundation
import UIKit
import AVFoundation
import AVKit
import Kingfisher
import SDWebImage
import WoWonderTimelineSDK


class GetPostRecord :AddReactionDelegate,SharePostDelegate,comment_CountsDelegate{

    var tableView : UITableView!
    var targetController : UIViewController!
    var selectedIndex = 0
    var sumAmount = 0
    var postArray = [[String:Any]]()
    var selectedIndexs = [[String:Any]]()
    var commentsIndex = [[String:Any]]()
    var comment_count = "0"
    var players : AVPlayer!
    var player = AVAudioPlayer()
    var isPlay = false
    var selectIndex: Int? = nil
    var isDownlodingComplete: Bool? = false
    var url: String? = nil
    var timer = Timer()
    var timer1 = Timer()
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "button", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    func getPostRecord (targetController: UIViewController,tableView : UITableView, indexpath:IndexPath, array : [[String:Any]], stackViewHeight: CGFloat,viewHeight: CGFloat, isHidden: Bool, viewColor :UIColor) -> UITableViewCell {
        self.targetController = targetController
        self.tableView = tableView
        self.postArray = array
        let index = postArray[indexpath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell") as! MusicCell
        cell.likeandcommentViewHeight.constant = viewHeight
        cell.stackViewHeight.constant = stackViewHeight
        cell.likesCountBtn.isHidden = isHidden
        cell.commentsCountBtn.isHidden = isHidden
        cell.sharesCountBtn.isHidden = isHidden
        cell.LikeBtn.isHidden = isHidden
        cell.CommentBtn.isHidden = isHidden
        cell.ShareBtn.isHidden = isHidden
        cell.contentView.backgroundColor = viewColor
        var names = ""
        var isPro = ""
        var isVerified = ""
        var postMap = ""
        if AppInstance.instance.vc == "userProfile" {
            self.sumAmount = 9
        }else if AppInstance.instance.vc == "newsFeedVC" {
            self.sumAmount = 3
        }
        
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)
        
        if let postRecord = index["postRecord"] as? String {
            let postURl = "\("https://wowonder.fra1.digitaloceanspaces.com/")\(postRecord)"
            if postURl != self.url{
            self.url = postURl
            self.downloadFileFromURL(url: URL(string: self.url ?? "")!)
            }
        }
        
        cell.playBtn.tag = indexpath.row
        cell.playBtn.addTarget(self, action: #selector(self.PlayBtn(sender:)), for: .touchUpInside)
        cell.slider.tag = indexpath.row
        cell.slider.addTarget(self, action: #selector(self.sliderValueChange(sender:)), for: .valueChanged)
                
        if let publisher = index["publisher"] as? [String:Any] {
            if let profilename = publisher["name"] as? String{
               names = profilename
            }
            if let avatarUrl =  publisher["avatar"] as? String {
                let url = URL(string: avatarUrl)
                cell.avatarImage.kf.setImage(with: url)
            }
            if let is_pro = publisher["is_pro"] as? String{
                isPro = is_pro
            }
            if let is_verify = publisher["verified"] as? String{
                isVerified = is_verify
            }
        }
        if let time = index["post_time"] as? String{
            cell.timeLabel.text! = time
        }
        
        if let textStatus = index["postText"] as? String {
            cell.statusLabel.text! = textStatus.htmlToString
            
        }
        
        if let map = index["postMap"] as? String{
            postMap = map
        }
        
        
        cell.statusLabel.handleURLTap { (URL) in
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        cell.statusLabel.handleHashtagTap { (hash) in
            let Storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "PostHashTagVC") as! PostHashTagController
            vc.hashtag = hash
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        
        if let commentsCount = index["post_comments"] as? String{
            cell.commentsCountBtn.setTitle("\(" ")\(commentsCount)", for: .normal)
        }
        
        for i in self.commentsIndex{
            if i["index"] as? Int == indexpath.row{
                cell.commentsCountBtn.setTitle("\(" ")\(i["count"] ?? "")", for: .normal)
            }
        }
        
        if let reactions = index["reaction"] as? [String:Any]{
            if let count = reactions["count"] as? Int{
                cell.likesCountBtn.setTitle("\(count)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
            }
            if let isreact  = reactions["is_reacted"] as? Bool {
                if isreact == true{
                    if let type = reactions["type"] as? String{
                        if type == "6"{
                            cell.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                            cell.LikeBtn.setTitleColor(.red, for: .normal)
                        }
                        else if type == "1"{
                            cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                        }
                        else if type == "2"{
                            cell.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                        }
                        else if type == "4"{
                            cell.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                        }
                        else if type == "5"{
                            cell.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                        }
                        else if type == "3"{
                            cell.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                        }
                    }
                }
                else{
                    cell.LikeBtn.setTitleColor(.lightGray, for: .normal)
                    cell.LikeBtn.setImage(UIImage(named:"like"), for: .normal)
                    cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                }
            }
        }
        
        
        for i in self.selectedIndexs{
            if i["index"] as? Int == indexpath.row{
                if let reaction = i["reaction"] as? String{
                    if reaction == "6"{
                        cell.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                        cell.LikeBtn.setTitleColor(.red, for: .normal)
                    }
                    else if reaction == "1"{
                        cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)

                    }
                    else if reaction == "2"{
                        cell.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                    }
                    else if reaction == "4"{
                        cell.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                    }
                    else if reaction == "5"{
                        cell.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                    }
                    else if reaction == "3"{
                        cell.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                    }
                        
                    else if reaction == ""{
                        cell.LikeBtn.setTitleColor(.lightGray, for: .normal)
                        cell.LikeBtn.setImage(UIImage(named:"like"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    }
                }
                if let count = i["count"] as? Int{
                    cell.likesCountBtn.setTitle("\(count)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
                }
            }
        }
        
        cell.LikeBtn.tag = indexpath.row
        cell.CommentBtn.tag = indexpath.row
        cell.moreBtn.tag = indexpath.row
        cell.avatarImage.tag = indexpath.row
        cell.nameLabel.tag = indexpath.row
        let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
        normalTapGesture.numberOfTapsRequired = 1
        longGesture.minimumPressDuration = 0.30
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
        
        cell.LikeBtn.addGestureRecognizer(normalTapGesture)
        cell.LikeBtn.addGestureRecognizer(longGesture)
        cell.avatarImage.addGestureRecognizer(gesture)
        cell.avatarImage.isUserInteractionEnabled = true
        cell.nameLabel.isUserInteractionEnabled = true
        cell.nameLabel.addGestureRecognizer(gestureonLabel)
        cell.likesCountBtn.tag = indexpath.row
        cell.likesCountBtn.addTarget(self, action: #selector(self.GotoPostReaction(sender:)), for: .touchUpInside)
        cell.ShareBtn.tag = indexpath.row
        cell.ShareBtn.addTarget(self, action: #selector(self.GotoShare(sender:)), for: .touchUpInside)
        cell.sharesCountBtn.addTarget(self, action: #selector(self.GotoShare(sender:)), for: .touchUpInside)
        cell.CommentBtn.addTarget(self, action: #selector(self.GotoComments(sender:)), for: .touchUpInside)
        cell.commentsCountBtn.addTarget(self, action: #selector(self.GotoComments(sender:)), for: .touchUpInside)
        cell.moreBtn.addTarget(self, action: #selector(self.More(sender:)), for: .touchUpInside)
        let imageAttachment =  NSTextAttachment()
        let imageAttachment1 =  NSTextAttachment()
        let imageAttachment2 = NSTextAttachment()
        imageAttachment.image = UIImage(named:"veirfied")
        imageAttachment1.image = UIImage(named: "flash-1")
        imageAttachment2.image = UIImage(named: "maps-and-flags")

        let imageOffsetY: CGFloat = -2.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        imageAttachment1.bounds = CGRect(x: 0, y: imageOffsetY, width: 11.0, height: 14.0)
        imageAttachment2.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        
        
        let attechmentString = NSAttributedString(attachment: imageAttachment)
        let attechmentString1 = NSAttributedString(attachment: imageAttachment1)
        let attechmentString2 = NSAttributedString(attachment: imageAttachment2)

        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs3 = [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font : UIFont(name: "Arial", size: 15.0)]
        
        let attributedString1 = NSMutableAttributedString(string: names, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(attributedString: attechmentString)
        let attributedString4 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString5 = NSMutableAttributedString(attributedString: attechmentString1)
        let attributedString6 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString7 = NSMutableAttributedString(attributedString: attechmentString2)
        let attributedString8 = NSMutableAttributedString(string: " ", attributes:attrs2)
        let attributedString9 = NSMutableAttributedString(string: postMap, attributes:attrs3 as [NSAttributedString.Key : Any])
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
        if postMap != ""{
            attributedString1.append(attributedString6)
            attributedString1.append(attributedString7)
            attributedString1.append(attributedString8)
            attributedString1.append(attributedString9)
        }
        
        cell.nameLabel.attributedText = attributedString1
        tableView.rowHeight = 200.0
        
        return cell
        
    }
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        self.selectedIndex = gesture.view!.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.targetController.present(vc, animated: true, completion: nil)
    }
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: gesture.view!.tag + sumAmount)) as! MusicCell
            self.audioPlayer.play()
            if let reactions = self.postArray[gesture.view!.tag]["reaction"] as? [String:Any]{
                var totalCount = 0
                if let count = reactions["count"] as? Int{
                    totalCount = count
                }
                if let is_react = reactions["is_reacted"] as? Bool{
                    if is_react == true{
                        self.reactions(index: gesture.view!.tag, reaction: "")
                        var localPostArray = self.postArray[gesture.view!.tag]["reaction"] as! [String:Any]
                        localPostArray["is_reacted"] = false
                        localPostArray["type"]  = ""
                        localPostArray["count"] = totalCount - 1
                        totalCount =  localPostArray["count"] as? Int ?? 0
                        self.postArray[gesture.view!.tag]["reaction"] = localPostArray
                cell.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
                        cell.LikeBtn.setImage(UIImage(named: "like"), for: .normal)
                        cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        cell.LikeBtn.setTitleColor(.lightGray, for: .normal)
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
                        var localPostArray = self.postArray[gesture.view!.tag]["reaction"] as! [String:Any]
                        localPostArray["is_reacted"] = true
                        localPostArray["type"]  = "Like"
                        localPostArray["count"] = totalCount + 1
                        localPostArray["Like"] = 1
                        totalCount =  localPostArray["count"] as? Int ?? 0
                        self.postArray[gesture.view!.tag]["reaction"] = localPostArray
                        self.reactions(index: gesture.view!.tag, reaction: "1")
            cell.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
                        cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                        cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
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
    
    @IBAction func GotoPostReaction(sender :UIButton){
        if let reaction = self.postArray[sender.tag]["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                if count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PostReactionVC") as! PostReactionController
                    if let postId = self.postArray[sender.tag]["post_id"] as? String{
                        vc.postId = postId
                    }
                    if let reactions = self.postArray[sender.tag]["reaction"] as? [String:Any]{
                        vc.reaction = reactions
                    }
                    targetController.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    private func reactions(index :Int, reaction: String) {
        performUIUpdatesOnMain {
            var postID = ""
            if let postId = self.postArray[index]["post_id"] as? String{
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
    
    func addReaction(reation: String) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedIndex+sumAmount)) as! MusicCell
        self.audioPlayer.play()
        //        self.postArray[gesture.view!.tag]["reaction"]!["Like"]   = true
        self.reactions(index: self.selectedIndex, reaction: reation)
        var localPostArray = self.postArray[self.selectedIndex]["reaction"] as! [String:Any]
        var totalCount = 0
        if let reactions = self.postArray[self.selectedIndex]["reaction"] as? [String:Any]{
            if let is_react = reactions["is_reacted"] as? Bool{
                if !is_react {
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                    localPostArray["count"] = totalCount + 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
            cell.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
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

            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            localPostArray["Love"] = 1
            localPostArray["2"] = 1

            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
        }
        else if reation == "3"{
            localPostArray["HaHa"] = 1
            localPostArray["3"] = 1

            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
        }
        else if reation == "4"{
            localPostArray["Wow"] = 1
            localPostArray["4"] = 1
            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
        }
        else if reation == "5"{
            localPostArray["Sad"] = 1
            localPostArray["5"] = 1
            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
            cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
        }
        else {
            localPostArray["Angry"] = 1
            localPostArray["6"] = 1
            self.postArray[self.selectedIndex]["reaction"] = localPostArray
            cell.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
            cell.LikeBtn.setTitleColor(.red, for: .normal)
        }
    }
    
    
    @IBAction func GotoShare(sender :UIButton){
        self.stopSound()
        self.selectedIndex = sender.tag
        let vc = Storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        targetController.present(vc, animated: true, completion: nil)
    }
    
    func sharePost() {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts =  [self.postArray[self.selectedIndex]]
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.targetController.present(vc, animated: true, completion: nil)
    }
    
    func sharePostTo(type:String) {
        if (type == "group") || (type == "page"){
            let Storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier : "MyGroups&PagesVC") as! MyGroupsandMyPagesController
            vc.type = type
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.targetController.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = Storyboard.instantiateViewController(withIdentifier : "SharePopUpVC") as! SharePopUpController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.targetController.present(vc, animated: true, completion: nil)
        }
    }
    
    func comment_Count() {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedIndex+sumAmount)) as! MusicCell
            
            let count = Int(self.comment_count) ?? 0
            let total = count + 1
            cell.commentsCountBtn.setTitle("\(" ")\(total)", for: .normal)
            self.postArray[self.selectedIndex]["post_comments"] = "\(total)"
            print(self.postArray[self.selectedIndex]["post_comments"])
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
    
    
    @IBAction func GotoComments (sender :UIButton){
        self.stopSound()
        let vc = Storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentController
        if let postId = self.postArray[sender.tag]["post_id"] as? String{
            vc.postId = postId
        }
        if let status = self.postArray[sender.tag]["comments_status"] as? String{
            vc.commentStatus = status
        }
        if let reaction = self.postArray[sender.tag]["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                vc.likes = count
            }
        }
//        if let comments = self.postArray[sender.tag]["get_post_comments"] as? [[String:Any]]{
//            vc.comments = comments
//        }
        if let counts = self.postArray[sender.tag]["post_comments"] as? String{
            self.comment_count = counts
        }
        self.selectedIndex = sender.tag
        vc.deleagte = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        targetController.present(vc, animated: true, completion: nil)
    }
    
    func selectPageandGroup(data: [String : Any],type : String) {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts =  [self.postArray[self.selectedIndex]]
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
        self.targetController.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func gotoUserProfile(gesture: UIGestureRecognizer){
        self.stopSound()
        if AppInstance.instance.vc == "myProfile"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if (AppInstance.instance.vc == "newsFeedVC"){
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "popularPostVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "hasTagPostVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "savedPostVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "showPostVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "eventDetailVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
        else if AppInstance.instance.vc == "pageVC"{
   
        }
        else if AppInstance.instance.vc == "groupVC"{
            if (AppInstance.instance.index != nil) && (gesture.view?.tag == 0){
                print(AppInstance.instance.index)
                let userInfo = ["userData":AppInstance.instance.index,"tag":gesture.view?.tag ?? 0,"type":"share"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
            else{
                let userInfo = ["userData":gesture.view!.tag,"type":"profile"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
            }
        }
    }
    
    
    @IBAction func More(sender: UIButton){
        var post_id: String? = nil
        var proType = 0
        if let postId = self.postArray[sender.tag]["post_id"] as? String{
            post_id = postId
        }
        if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let pro_type = publisher["pro_type"] as? String{
                proType = Int(pro_type) ?? 0
            }
        }
        let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        if let is_saved = self.postArray[sender.tag]["is_post_saved"] as? Bool{
            if !is_saved{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Save Post", comment: "Save Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.postArray[sender.tag]["is_post_saved"] = true
                        SavePostManager.sharedInstance.savedPost(targetController: self.targetController, postId: post_id ?? "", action: "save")
                    }
                }))
            }
            else{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Unsave Post", comment: "Unsave Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.postArray[sender.tag]["is_post_saved"] = false
                        SavePostManager.sharedInstance.savedPost(targetController: self.targetController, postId: post_id ?? "", action: "save")
                    }
                }))
            }
        }
        if let copyText = self.postArray[sender.tag]["postText"] as? String{
            if copyText != ""{
                alert.addAction(UIAlertAction(title: "Copy Text", style: .default, handler: { (_) in
                    UIPasteboard.general.string = copyText
                    self.targetController.view.makeToast(NSLocalizedString("Text copied to clipboard", comment: "Text copied to clipboard"))
                }))
            }
        }
        if let copyLink = self.postArray[sender.tag]["url"] as? String{
            alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Link", comment: "Copy Link"), style: .default, handler: { (_) in
                UIPasteboard.general.string = copyLink
                self.targetController.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
            }))
        }
        if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost != UserData.getUSER_ID() || is_myPost == UserData.getUSER_ID() {
                    if let is_report = self.postArray[sender.tag]["is_post_reported"] as? Bool{
                        if !is_report{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Report Post", comment: "Report Post"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                            ReportPostManager.sharedInstance.reportedPost(targetController: self.targetController, postId: post_id ?? "")
                                }
                            }))
                        }
                    }
                }
            }
        }
        
        
        if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    var postId = ""
                    var text = ""
                    var privacy = ""
                    if let postid = self.postArray[sender.tag]["post_id"] as? String{
                        postId = postid
                    }
                    if let texts = self.postArray[sender.tag]["postText"] as? String{
                        text = texts
                    }
                    if let privacyi = self.postArray[sender.tag]["postPrivacy"] as? String{
                        privacy = privacyi
                    }
                alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Edit Post", comment: "Edit Post"))", style: .default, handler: { (_) in
                        if AppInstance.instance.vc == "myProfile"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "newsFeedVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "popularPostVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "hasTagPostVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "savedPostVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "showPostVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "eventDetailVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "pageVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "groupVC"{
                            let userInfo = ["userData":sender.tag,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                    }))
                }
            }
        }
        
        
        if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if (is_myPost == UserData.getUSER_ID()) {
                    alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Boost Post", comment: "Boost Post"))", style: .default, handler: { (_) in
                        let status = Reach().connectionStatus()
                        switch status {
                        case .unknown, .offline:
                            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                        case .online(.wwan), .online(.wiFi):
                            if (proType >= 2){
                                BoostPostManager.sharedInstance.boostPosts(targetController: self.targetController, postId: post_id ?? "")
                            }
                            else{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "UpgradeVC") as! UpgradeController
                                vc.modalPresentationStyle = .fullScreen
                                vc.modalTransitionStyle = .coverVertical
                                self.targetController.present(vc, animated: true, completion: nil)
                            }

                            
//                            BoostPostManager.sharedInstance.boostPosts(targetController: self.targetController, postId: post_id ?? "")
                        }
                    }))
                }
            }
        }
        
        if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    if let enableComment = self.postArray[sender.tag]["comments_status"] as? String{
                        let post_Id = Int(post_id ?? "")
                        if enableComment == "1"{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Disable Comments", comment: "Disable Comments"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    self.postArray[sender.tag]["comments_status"] = "0"
                                    
                                    CommentDisableManager.sharedIntsance.disableComment(targetController: self.targetController, postId: post_Id ?? 0)
                                }
                            }))
                        }
                        else{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Enable Comments", comment: "Enable Comments"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    self.postArray[sender.tag]["comments_status"] = "1"
                                    CommentDisableManager.sharedIntsance.disableComment(targetController: self.targetController, postId: post_Id ?? 0)
                                }
                            }))
                            
                        }
                    }
                }
            }
        }
        
           if let publisher = self.postArray[sender.tag]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
            if is_myPost == UserData.getUSER_ID(){
                //                alert.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                //                }))
                //                alert.addAction(UIAlertAction(title: "Boost Post", style: .default, handler: { (_) in
                //                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .default, handler: { (_) in
                    DeletePostManager.sharedInstance.postDelete(targetController: self.targetController,   postId: post_id ?? "") { (success) in
                        if AppInstance.instance.vc == "myProfile"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "newsFeedVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "popularPostVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "hasTagPostVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "savedPostVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "showPostVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "eventDetailVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "pageVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                        else if AppInstance.instance.vc == "groupVC"{
                            let userInfo = ["userData":sender.tag,"type":"delete"] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                        }
                    }
                }))
            }
        }
    }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.targetController.view
            popoverController.sourceRect = CGRect(x: self.targetController.view.bounds.midX, y: self.targetController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.targetController.present(alert, animated: true, completion: {
        })
    }
    
    
    func sharePostLink() {
        
        // text to share
        var text = ""
        if let postUrl =  self.postArray[selectedIndex]["url"] as? String{
            text = postUrl
        }
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.targetController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional,)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
        
        // present the view controller
        self.targetController.present(activityViewController, animated: true, completion: nil)
        
    }
    

    func stopSound (){
        self.timer1.invalidate()
        self.timer.invalidate()
        self.player.pause()
    }
    
    
    @IBAction func PlayBtn (sender:UIButton){
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: sender.tag + sumAmount)) as! MusicCell
        if self.isPlay == false{
            if self.isDownlodingComplete == true{
                self.selectIndex = sender.tag
                cell.indicatorView.stopAnimating()
                cell.playBtn.setImage(UIImage(named: "pause-button"), for: .normal)
                cell.slider.maximumValue = Float(self.player.duration)
                self.player.play()
                self.isPlay = true
                self.timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            }
            else{
                self.isPlay = true
                cell.playBtn.setImage(UIImage(named: "Plays"), for: .normal)
                self.selectIndex = sender.tag
                cell.indicatorView.startAnimating()
                self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.checkDownload), userInfo: nil, repeats: true)             }
        }
        else{
            cell.playBtn.setImage(UIImage(named: "Plays"), for: .normal)
            self.selectIndex = sender.tag
            self.isPlay = false
            self.timer1.invalidate()
            self.player.pause()
        }
    }
    
    @objc func checkDownload(){
        if self.isDownlodingComplete == true{
            if self.isPlay == true{
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectIndex! + sumAmount)) as! MusicCell
                cell.indicatorView.stopAnimating()
                self.isPlay = false
            }
            self.timer.invalidate()
        }
    }
    
    @IBAction func updateSlider(){
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectIndex! + sumAmount)) as! MusicCell
        cell.slider.value = Float(self.player.currentTime)
    }
    
    func downloadFileFromURL(url:URL){
        DispatchQueue.main.async {
            var downloadTask:URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URL, response, error) -> Void in
                if error == nil{
                    print("downloading Completed")
                    self?.isDownlodingComplete = true
                    self?.play(url: (URL)!)
                }
                else{
                    print(error?.localizedDescription)
                }
            })
            downloadTask.resume()
        }
    }
    
    func play(url: URL) {
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
            self.player.prepareToPlay()
            player.volume = 1.0
            //            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    @IBAction func sliderValueChange(sender: UISlider) {
        self.player.stop()
        self.player.currentTime = TimeInterval(sender.value)
        self.player.prepareToPlay()
        self.player.play()
    }
    
    
    
    static let sharedInstance = GetPostRecord()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
        }
    }
}

