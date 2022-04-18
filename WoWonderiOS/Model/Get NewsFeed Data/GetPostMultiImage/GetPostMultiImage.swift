
import Foundation
import UIKit
import AVFoundation
import AVKit
import Kingfisher
import SDWebImage
import WoWonderTimelineSDK


class GetPostMultiImage: AddReactionDelegate,SharePostDelegate,comment_CountsDelegate{
    
    var targetController : UIViewController!
    var image : UIImage!
    var sumAmount = 0
    var tableView : UITableView!
    var selectedIndex = 0
    var section = 0
    var selection = [Int]()
    var selectIndex : Int? = nil
    var postArray = [[String:Any]]()
    var selectedIndexs = [[String:Any]]()
    var commentsIndex = [[String:Any]]()
    var comment_count = "0"
    var imageCount = 3
    var reaction: String? = nil
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "button", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    func getMultiImage (targetController : UIViewController,tableView : UITableView, indexpath:IndexPath, array : [[String:Any]],stackViewHeight: CGFloat,viewHeight: CGFloat, isHidden: Bool, viewColor :UIColor) -> UITableViewCell {
        var index = array[indexpath.row]
        self.targetController = targetController
        self.tableView = tableView
        self.postArray = array
        
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)
        if AppInstance.instance.vc == "userProfile" {
            self.sumAmount = 9
        }else if AppInstance.instance.vc == "newsFeedVC" {
            self.sumAmount = 3
        }
        
        var multiImageArray = [[String : Any]]()
        if  let multiImages = index["photo_multi"] as? [[String :Any]] {
            for i in multiImages {
                multiImageArray.append(i)
            }
        }
        if multiImageArray.count == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiImage2") as! MultiImage2
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 320.0
            var names = ""
            var isPro = ""
            var isVerified = ""
            var postMap = ""
            if let time = index["post_time"] as? String{
                cell.timeLabel.text! = time
            }
            if let textStatus = index["postText"] as? String {
                cell.statusLabel.text! = textStatus.htmlToString
            }
            if let publisher = index["publisher"] as? [String:Any] {
                if let profilename = publisher["name"] as? String{
                   names = profilename
                }
                if let avatarUrl =  publisher["avatar"] as? String {
                    let url = URL(string: avatarUrl)
                    cell.profileImage.kf.setImage(with: url)
                }
                if let is_pro = publisher["is_pro"] as? String{
                    isPro = is_pro
                }
                if let is_verify = publisher["verified"] as? String{
                    isVerified = is_verify
                }
            }
            
            if let map = index["postMap"] as? String{
                postMap = map
            }
            
            cell.statusLabel.handleURLTap { (URL) in
                print("Tap URL")
                UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            }
            cell.statusLabel.handleHashtagTap { (hash) in
                print(hash)
                let Storyboard = UIStoryboard(name: "Search", bundle: nil)
                let vc = Storyboard.instantiateViewController(withIdentifier: "PostHashTagVC") as! PostHashTagController
                vc.hashtag = hash
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
            
            var image1 = 0
            var image2 = 0
            for i in multiImageArray{
                
                if image1 == 0 {
                    if let image = i["image"] as? String {
                        let url = URL(string: image)
                        cell.imageView1.kf.setImage(with: url)
                        image1 = 1
                        
                    }
                }
                else  if image2 == 0 {
                    if let image = i["image"] as? String {
                        let url = URL(string: image)
                        cell.imageView2.kf.setImage(with: url)
                        image2 = 1
                    }
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
            
            if let commentsCount = index["post_comments"] as? String{
                cell.commentsCountBtn.setTitle("\(" ")\(commentsCount) Comments", for: .normal)
            }
            
            
            for i in self.commentsIndex{
                if i["index"] as? Int == indexpath.row{
                    cell.commentsCountBtn.setTitle("\(" ")\(i["count"] ?? "") Comments", for: .normal)
                }
            }
            
            cell.imageAction = { [unowned self] in
                print(indexpath.row)
                let vc = self.Storyboard.instantiateViewController(withIdentifier: "ShowMultiImageVC") as! ShowMultiImageController
                vc.selectedIndex = indexpath.row
                vc.posts.append(index)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .coverVertical
                self.targetController.present(vc, animated: true, completion: nil)
            }
            cell.commentAction = {[unowned self] in
                let vc = self.Storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentController
                if let postId = index["post_id"] as? String{
                    vc.postId = postId
                }
                if let reaction = index["reaction"] as? [String:Any]{
                    if let count = reaction["count"] as? Int{
                        vc.likes = count
                    }
                }
//                if let comments = index["get_post_comments"] as? [[String:Any]]{
//                    vc.comments = comments
//                }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                targetController.present(vc, animated: true, completion: nil)
            }
            cell.likeCountAction = {[unowned self] in
                if let reaction = index["reaction"] as? [String:Any]{
                    if let count = reaction["count"] as? Int{
                        if count > 0 {
                            let vc = self.Storyboard.instantiateViewController(withIdentifier: "PostReactionVC") as! PostReactionController
                            if let postId = index["post_id"] as? String{
                                vc.postId = postId
                            }
                            if let reactions = index["reaction"] as? [String:Any]{
                                vc.reaction = reactions
                            }
                            targetController.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
            cell.moreAction = {[unowned self] in
                var post_id: String? = nil
                if let postId = index["post_id"] as? String{
                    post_id = postId
                }
                let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
                
                alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                
                if let is_saved = index["is_post_saved"] as? Bool{
                    if !is_saved{
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Save Post", comment: "Save Post"), style: .default, handler: { (_) in
                            let status = Reach().connectionStatus()
                            switch status {
                            case .unknown, .offline:
                                self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                            case .online(.wwan), .online(.wiFi):
                                index["is_post_saved"] = true
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
                                index["is_post_saved"] = true
                                SavePostManager.sharedInstance.savedPost(targetController: self.targetController, postId: post_id ?? "", action: "save")
                            }
                        }))
                    }
                }
                if let copyText = index["postText"] as? String{
                    if copyText != ""{
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Text", comment: "Copy Text"), style: .default, handler: { (_) in
                            UIPasteboard.general.string = copyText
                            self.targetController.view.makeToast(NSLocalizedString("Text copied to clipboard", comment: "Text copied to clipboard"))
                        }))
                    }
                }
                if let copyLink = index["url"] as? String{
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Link", comment: "Copy Link"), style: .default, handler: { (_) in
                        UIPasteboard.general.string = copyLink
                        self.targetController.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
                    }))
                }
                if let publisher = index["publisher"] as? [String:Any]{
                    if let is_myPost = publisher["user_id"] as? String{
                        if is_myPost != UserData.getUSER_ID() || is_myPost == UserData.getUSER_ID() {
                            if let is_report = index["is_post_reported"] as? Bool{
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
                
                
                if let publisher = index["publisher"] as? [String:Any]{
                    if let is_myPost = publisher["user_id"] as? String{
                        if is_myPost == UserData.getUSER_ID(){
                            var postId = ""
                            var text = ""
                            var privacy = ""
                            if let postid = index["post_id"] as? String{
                                postId = postid
                            }
                            if let texts = index["postText"] as? String{
                                text = texts
                            }
                            if let privacyi = index["postPrivacy"] as? String{
                                privacy = privacyi
                            }
                        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Edit Post", comment: "Edit Post"))", style: .default, handler: { (_) in
                                if AppInstance.instance.vc == "myProfile"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "newsFeedVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "popularPostVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "hasTagPostVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "savedPostVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "showPostVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "eventDetailVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "pageVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                                else if AppInstance.instance.vc == "groupVC"{
                                    let userInfo = ["userData":indexpath.row,"postId":postId,"text":text,"privacy":privacy,"type":"edit"] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                }
                            }))
                        }
                    }
                }
    
                if let publisher = index["publisher"] as? [String:Any]{
                    if let is_myPost = publisher["user_id"] as? String{
                        if (is_myPost == UserData.getUSER_ID()) {
                            alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Boost Post", comment: "Boost Post"))", style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    BoostPostManager.sharedInstance.boostPosts(targetController: self.targetController, postId: post_id ?? "")
                                }
                            }))
                        }
                    }
                }
                
                if let publisher = index["publisher"] as? [String:Any]{
                    if let is_myPost = publisher["user_id"] as? String{
                        if is_myPost == UserData.getUSER_ID(){
                            //                alert.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                            //                }))
                            //                alert.addAction(UIAlertAction(title: "Boost Post", style: .default, handler: { (_) in
                            //                }))
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    //            DeletePostManager.sharedInstance.postDelete(targetController: self.targetController, postId: post_id ?? "")
                                    DeletePostManager.sharedInstance.postDelete(targetController: self.targetController,   postId: post_id ?? "") { (success) in
                                        if AppInstance.instance.vc == "myProfile"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "newsFeedVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "popularPostVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "hasTagPostVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "savedPostVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "showPostVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "eventDetailVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "pageVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                        else if AppInstance.instance.vc == "groupVC"{
                                            let userInfo = ["userData":indexpath.row,"type":"delete"] as [String : Any]
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                                        }
                                    }
                                }
                            }))
                        }
                    }
                }
                alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
                    print("User click Dismiss button")
                }))
                self.targetController.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }
            cell.longAction = {[unowned self] in
                self.selectedIndex = indexpath.row
                let vc = self.Storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.targetController.present(vc, animated: true, completion: nil)
            }
           
            cell.addREact = {[unowned self] in
                print(self.selectedIndex)
                  let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedIndex+sumAmount)) as! MultiImage2
                  cell.addREact?()
                self.reactions(index: self.selectedIndex, reaction: self.reaction ?? "1")
                  var localPostArray = array[self.selectedIndex]["reaction"] as! [String:Any]
                  var totalCount = 0
                  if let reactions = index["reaction"] as? [String:Any]{
                      if let is_react = reactions["is_reacted"] as? Bool{
                          if !is_react {
                              if let count = reactions["count"] as? Int{
                                  totalCount = count
                              }
                              localPostArray["count"] = totalCount + 1
                              totalCount =  localPostArray["count"] as? Int ?? 0
                              cell.likesCountBtn.setTitle("\(totalCount)\(" Reactions")", for: .normal)
                          }
                          else{
                              if let count = reactions["count"] as? Int{
                                  totalCount = count
                              }
                          }
                      }
                  }
                let action = ["count": totalCount, "reaction": self.reaction ?? "","index": self.selectedIndex] as [String : Any]
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
                localPostArray["type"]  = self.reaction
                if self.reaction == "1"{
                      localPostArray["Like"] = 1
                      localPostArray["1"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                      cell.LikeBtn.setTitle("   Like", for: .normal)
                      cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                  }
                else if self.reaction == "2"{
                      localPostArray["Love"] = 1
                      localPostArray["2"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                      cell.LikeBtn.setTitle("   Love", for: .normal)
                      cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                  }
                else if self.reaction == "3"{
                      localPostArray["HaHa"] = 1
                      localPostArray["3"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                      cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                      cell.LikeBtn.setTitle("   Haha", for: .normal)
                  }
                else if self.reaction == "4"{
                      localPostArray["Wow"] = 1
                      localPostArray["4"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                      cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                      cell.LikeBtn.setTitle("   Wow", for: .normal)
                  }
                else if self.reaction == "5"{
                      localPostArray["Sad"] = 1
                      localPostArray["5"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                      cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                      cell.LikeBtn.setTitle("   Sad", for: .normal)
                  }
                  else {
                      localPostArray["Angry"] = 1
                      localPostArray["6"]  = 1
                      index["reaction"] = localPostArray
                      cell.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                      cell.LikeBtn.setTitle("   Angry", for: .normal)
                      cell.LikeBtn.setTitleColor(.red, for: .normal)
                }
            }
            cell.normalAction = {[unowned self] in
                let status = Reach().connectionStatus()
                switch status {
                case .unknown, .offline:
                    self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                case .online(.wwan), .online(.wiFi):
                    if let images_count = index["photo_multi"] as? [[String:Any]]{
                        if images_count.count == 2{
                            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: indexpath.row + sumAmount)) as! MultiImage2
                            if let reactions = index["reaction"] as? [String:Any]{
                                var totalCount = 0
                                if let count = reactions["count"] as? Int{
                                    totalCount = count
                                }
                                if let is_react = reactions["is_reacted"] as? Bool{
                                    print(is_react)
                                    if is_react == true{
                                        self.reactions(index: indexpath.row, reaction: "")
                                        var localPostArray = index["reaction"] as! [String:Any]
                                        localPostArray["is_reacted"] = false
                                        localPostArray["type"]  = ""
                                        localPostArray["count"] = totalCount - 1
                                        totalCount =  localPostArray["count"] as? Int ?? 0
                                        index["reaction"] = localPostArray
                                        cell.likesCountBtn.setTitle("\(totalCount)\(" Reactions")", for: .normal)
                                        cell.LikeBtn.setImage(UIImage(named: "like"), for: .normal)
                                        cell.LikeBtn.setTitle("  Like", for: .normal)
                                        cell.LikeBtn.setTitleColor(.lightGray, for: .normal)
                                        let action = ["count": totalCount, "reaction": "","index":indexpath.row ?? 0] as [String : Any]
                                        var count = 0
                                        if self.selectedIndexs.count == 0{
                                            self.selectedIndexs.append(action)
                                        }
                                        else{
                                            for i in self.selectedIndexs{
                                                count += 1
                                                if i["index"] as? Int == indexpath.row{
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
                                        var localPostArray = index["reaction"] as! [String:Any]
                                        localPostArray["is_reacted"] = true
                                        localPostArray["type"]  = "1"
                                        localPostArray["count"] = totalCount + 1
                                        localPostArray["Like"] = 1
                                        localPostArray["1"]  = 1
                                        totalCount =  localPostArray["count"] as? Int ?? 0
                                        index["reaction"] = localPostArray
                                        self.reactions(index: indexpath.row, reaction: "1")
                                        cell.likesCountBtn.setTitle("\(totalCount)\(" Reactions")", for: .normal)
                                        cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                                        cell.LikeBtn.setTitle("   Like", for: .normal)
                                        cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                                        let action = ["count": totalCount, "reaction": "1","index":indexpath.row ?? 0] as [String : Any]
                                        var count = 0
                                        print(self.selectedIndexs.count)
                                        if self.selectedIndexs.count == 0 {
                                            self.selectedIndexs.append(action)
                                        }
                                        else{
                                            for i in self.selectedIndexs{
                                                count += 1
                                                if i["index"] as? Int == indexpath.row{
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
                }
            }
            
            cell.shareBtn.tag = indexpath.row
            cell.profileImage.tag = indexpath.row
            cell.profileName.tag = indexpath.row
            cell.shareBtn.addTarget(self, action: #selector(self.GotoShare(sender:)), for: .touchUpInside)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
            let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
            cell.profileImage.addGestureRecognizer(gesture)
            cell.profileImage.isUserInteractionEnabled = true
            cell.profileName.isUserInteractionEnabled = true
            cell.profileName.addGestureRecognizer(gestureonLabel)
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
            
            cell.profileName.attributedText = attributedString1
            cell.layoutIfNeeded()
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiImage3") as! MultiImage3
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 590.0
            cell.likeandcommentViewHeight.constant = viewHeight
            cell.stackViewHeight.constant = stackViewHeight
            cell.likesCountBtn.isHidden = isHidden
            cell.commentsCountBtn.isHidden = isHidden
            cell.sharesCountBtn.isHidden = isHidden
            cell.LikeBtn.isHidden = isHidden
            cell.commentBtn.isHidden = isHidden
            cell.shareBtn.isHidden = isHidden
            cell.contentView.backgroundColor = viewColor
            var names = ""
            var isPro = ""
            var isVerified = ""
            var postMap = ""
            
            if multiImageArray.count == 3 {
                cell.countLabel.isHidden = true
            }
            else {
                cell.countLabel.isHidden = false
                let labelCount = multiImageArray.count - 3
                cell.countLabel.text = "\("+")\(labelCount)"
            }
            
            
            if let time = index["post_time"] as? String{
                cell.timeLabel.text! = time
            }
            
            if let textStatus = index["postText"] as? String {
                cell.statusLabel.text! = textStatus.htmlToString
            }
            
            if let publisher = index["publisher"] as? [String:Any] {
                if let profilename = publisher["name"] as? String{
                    names = profilename
                }
                if let avatarUrl =  publisher["avatar"] as? String {
                    let url = URL(string: avatarUrl)
                    cell.profileImage.kf.setImage(with: url)
                }
                if let is_pro = publisher["is_pro"] as? String{
                    isPro = is_pro
                }
                if let is_verify = publisher["verified"] as? String{
                    isVerified = is_verify
                }
            }
            
            if let map = index["postMap"] as? String{
                postMap = map
            }
            
            cell.statusLabel.handleURLTap { (URL) in
                print("Tap URL")
                UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            }
            cell.statusLabel.handleHashtagTap { (hash) in
                print(hash)
                let Storyboard = UIStoryboard(name: "Search", bundle: nil)
                let vc = Storyboard.instantiateViewController(withIdentifier: "PostHashTagVC") as! PostHashTagController
                vc.hashtag = hash
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
            var image1 = 0
            var image2 = 0
            var image3 = 0
            for i in multiImageArray{
                if image1 == 0 {
                    if let image = i["image"] as? String {
                        let url = URL(string: image)
                        cell.imageView1.kf.setImage(with: url)
                        image1 = 1
                    }
                }
                else  if image2 == 0 {
                    if let image = i["image"] as? String {
                        let url = URL(string: image)
                        cell.imageView2.kf.setImage(with: url)
                        image2 = 1
                    }
                }
                else if image3 == 0 {
                    if let image = i["image"] as? String {
                        let url = URL(string: image)
                        cell.imageView3.kf.setImage(with: url)
                        image3 = 1
                    }
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
            
            if let commentsCount = index["post_comments"] as? String{
                cell.commentsCountBtn.setTitle("\(" ")\(commentsCount) Comments", for: .normal)
            }
            
            for i in self.commentsIndex{
                if i["index"] as? Int == indexpath.row{
                    cell.commentsCountBtn.setTitle("\(" ")\(i["count"] ?? "") Comments", for: .normal)
                }
            }
            
            cell.LikeBtn.tag = indexpath.row
            cell.commentBtn.tag = indexpath.row
            cell.shareBtn.tag = indexpath.row
            cell.imageView1.tag = indexpath.row
            cell.imageView2.tag = indexpath.row
            cell.imageView3.tag = indexpath.row
            cell.likesCountBtn.tag = indexpath.row
            cell.profileImage.tag = indexpath.row
            cell.moreBtn.tag = indexpath.row
            cell.prfileName.tag = indexpath.row
            let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
            normalTapGesture.numberOfTapsRequired = 1
            longGesture.minimumPressDuration = 0.30
            cell.LikeBtn.addGestureRecognizer(normalTapGesture)
            cell.LikeBtn.addGestureRecognizer(longGesture)
            cell.likesCountBtn.addTarget(self, action: #selector(self.GotoPostReaction(sender:)), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(self.GotoShare(sender:)), for: .touchUpInside)
            cell.sharesCountBtn.addTarget(self, action: #selector(self.GotoShare(sender:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(self.GotoComments(sender:)), for: .touchUpInside)
            cell.commentsCountBtn.addTarget(self, action: #selector(self.GotoComments(sender:)), for: .touchUpInside)
            cell.moreBtn.addTarget(self, action: #selector(self.More(sender:)), for: .touchUpInside)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
            let gestureonLabel = UITapGestureRecognizer(target: self, action: #selector(self.gotoUserProfile(gesture:)))
            let Imagegesture1 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
            let Imagegesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
            let Imagegesture3 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
            cell.profileImage.addGestureRecognizer(gesture)
            cell.profileImage.isUserInteractionEnabled = true
            cell.prfileName.isUserInteractionEnabled = true
            cell.prfileName.addGestureRecognizer(gestureonLabel)
            cell.imageView1.addGestureRecognizer(Imagegesture1)
            cell.imageView1.isUserInteractionEnabled = true
            cell.imageView2.addGestureRecognizer(Imagegesture2)
            cell.imageView2.isUserInteractionEnabled = true
            cell.imageView3.addGestureRecognizer(Imagegesture3)
            cell.imageView3.isUserInteractionEnabled = true
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
            cell.prfileName.attributedText = attributedString1
             cell.layoutIfNeeded()
            return cell
        }
    }
    
    func comment_Count() {
        print("Check")
    }
    
    
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            self.audioPlayer.play()
            if let images_count = self.postArray[gesture.view!.tag]["photo_multi"] as? [[String:Any]]{
                if images_count.count == 2{
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: gesture.view!.tag + sumAmount)) as! MultiImage2
                    if let reactions = self.postArray[gesture.view!.tag]["reaction"] as? [String:Any]{
                        var totalCount = 0
                        if let count = reactions["count"] as? Int{
                            totalCount = count
                        }
                        if let is_react = reactions["is_reacted"] as? Bool{
                            print(is_react)
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
                                localPostArray["type"]  = "1"
                                localPostArray["count"] = totalCount + 1
                                localPostArray["Like"] = 1
                                localPostArray["1"]  = 1
                                totalCount =  localPostArray["count"] as? Int ?? 0
                                self.postArray[gesture.view!.tag]["reaction"] = localPostArray
                                self.reactions(index: gesture.view!.tag, reaction: "1")
                    cell.likesCountBtn.setTitle("\(totalCount)\(" ")\(NSLocalizedString("Reactions", comment: "Reactions"))", for: .normal)
                                cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                cell.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
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
                else{
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: gesture.view!.tag + sumAmount)) as! MultiImage3
                    if let reactions = self.postArray[gesture.view!.tag]["reaction"] as? [String:Any]{
                        var totalCount = 0
                        if let count = reactions["count"] as? Int{
                            totalCount = count
                        }
                        if let is_react = reactions["is_reacted"] as? Bool{
                            print(is_react)
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
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
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
                                localPostArray["type"]  = "1"
                                localPostArray["count"] = totalCount + 1
                                localPostArray["Like"] = 1
                                localPostArray["1"]  = 1
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
        }
    }
    
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        self.selectedIndex = gesture.view!.tag
        let vc = Storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.targetController.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func gotoUserProfile(gesture: UIGestureRecognizer){
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
    
    
    @IBAction func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let imageView = gesture.view as? UIImageView {
            print("ImageTapped","\(imageView.tag)")
            let vc = Storyboard.instantiateViewController(withIdentifier: "ShowMultiImageVC") as! ShowMultiImageController
            vc.selectedIndex = imageView.tag
            vc.posts.append(self.postArray[imageView.tag])
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .coverVertical
            self.targetController.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func GotoPostReaction(sender :UIButton){
        if let reaction = self.postArray[sender.tag]["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                if count > 0 {
                    let vc = Storyboard.instantiateViewController(withIdentifier: "PostReactionVC") as! PostReactionController
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
    
    @IBAction func GotoShare(sender :UIButton){
        self.selectedIndex = sender.tag
        let vc = Storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        targetController.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func GotoComments (sender :UIButton){
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
    private func reactions(index :Int, reaction: String){
        performUIUpdatesOnMain {
            print(reaction)
            var postID = ""
            if let postId = self.postArray[index]["post_id"] as? String{
                postID = postId
            }
            AddReactionManager.sharedInstance.addReaction(postId: postID, reaction:reaction) { (success, authError, error) in
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
        self.audioPlayer.play()
           if self.imageCount == 2{
            print(selectedIndex)
            self.reaction = reation
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedIndex+sumAmount)) as! MultiImage2
            cell.addREact?()
            self.imageCount = 3

        }
            else{
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.selectedIndex+sumAmount)) as! MultiImage3
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
                            cell.likesCountBtn.setTitle("\(totalCount)\(" Reactions")", for: .normal)
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
                    localPostArray["1"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
        cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                }
                else if reation == "2"{
                    localPostArray["Love"] = 1
                    localPostArray["2"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
            cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                    cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                }
                else if reation == "3"{
                    localPostArray["HaHa"] = 1
                    localPostArray["3"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                    cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                }
                else if reation == "4"{
                    localPostArray["Wow"] = 1
                    localPostArray["4"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                    cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                    cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                }
                else if reation == "5"{
                    localPostArray["Sad"] = 1
                    localPostArray["5"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                    cell.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                    cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                }
                else {
                    localPostArray["Angry"] = 1
                    localPostArray["6"]  = 1
                    self.postArray[self.selectedIndex]["reaction"] = localPostArray
                    cell.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                    cell.LikeBtn.setTitle("\("   ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                    cell.LikeBtn.setTitleColor(.red, for: .normal)
                }
            }
//        }
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
    func sharePostLink() {
        var text = ""
        if let postUrl =  self.postArray[selectedIndex]["url"] as? String{
            text = postUrl
        }
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.targetController.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
        self.targetController.present(activityViewController, animated: true, completion: nil)
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
                        self.postArray[sender.tag]["is_post_saved"] = true
                        SavePostManager.sharedInstance.savedPost(targetController: self.targetController, postId: post_id ?? "", action: "save")
                    }
                }))
            }
        }
        if let copyText = self.postArray[sender.tag]["postText"] as? String{
            if copyText != ""{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Text", comment: "Copy Text"), style: .default, handler: { (_) in
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
                if is_myPost != UserData.getUSER_ID() || is_myPost == UserData.getUSER_ID(){
                    if let is_report = self.postArray[sender.tag]["is_post_reported"] as? Bool{
                        if !is_report{
                            alert.addAction(UIAlertAction(title: "Report Post", style: .default, handler: { (_) in
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
                        let status = Reach().connectionStatus()
                        switch status {
                        case .unknown, .offline:
                            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                        case .online(.wwan), .online(.wiFi):
                            //            DeletePostManager.sharedInstance.postDelete(targetController: self.targetController, postId: post_id ?? "")
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
                        }
                    }))
                }
            }
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.targetController.view
            popoverController.sourceRect = CGRect(x: self.targetController.view.bounds.midX, y: self.targetController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.targetController.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    static let sharedInstance = GetPostMultiImage()
    private init() {}
    
}
