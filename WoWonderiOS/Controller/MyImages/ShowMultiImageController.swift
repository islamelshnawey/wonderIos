//
//  ShowMultiImageController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 4/28/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import ImageSlideshow

class ShowMultiImageController: UIViewController,AddReactionDelegate,SharePostDelegate {
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    
    var multiImages = [[String:Any]]()
    var reactions = [String:Any]()
    var comments = [[String:Any]]()
    var posts = [[String:Any]]()
    var postid: String? = nil
    var isAlbum = false
    var selectedIndex = 0
    
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isAlbum == true{
            if let images = self.posts[0]["photo_album"] as? [[String:Any]]{
                self.multiImages = images
            }
        }
        else{
        if let images = self.posts[0]["photo_multi"] as? [[String:Any]]{
            self.multiImages = images
        }
    }
        if let reaction = self.posts[0]["reaction"] as? [String:Any]{
            self.reactions = reaction
        }
        if let post_id = self.posts[0]["post_id"] as? String{
            self.postid = post_id
        }
        if let comments = self.posts[0]["get_post_comments"] as? [[String:Any]]{
            self.comments = comments
        }
        
        let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
        normalTapGesture.numberOfTapsRequired = 1
        longGesture.minimumPressDuration = 0.30
        self.LikeBtn.addGestureRecognizer(normalTapGesture)
        self.LikeBtn.addGestureRecognizer(longGesture)
        if let count = self.reactions["count"] as? Int{
            self.likesCountLabel.text = "\(count)"
        }
        if let isReacted = self.reactions["is_reacted"] as? Bool{
            if isReacted == true{
                if let type = self.reactions["type"] as? String{
                    if type == "6"{
                        self.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
                        self.LikeBtn.setTitle("   Angry", for: .normal)
                        self.LikeBtn.setTitleColor(.red, for: .normal)
                    }
                    else if type == "1"{
                        self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                        self.LikeBtn.setTitle("   Like", for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                    }
                    else if type == "2"{
                        self.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
                        self.LikeBtn.setTitle("   Love", for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                    }
                    else if type == "4"{
                        self.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("   Wow", for: .normal)
                    }
                    else if type == "5"{
                        self.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("   Sad", for: .normal)
                    }
                    else if type == "3"{
                        self.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
                        self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                        self.LikeBtn.setTitle("   Haha", for: .normal)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var imagess = [KingfisherSource]()
        for i in self.multiImages{
            imagess.append(KingfisherSource(urlString: i["image"] as? String ?? "")!)
        }
        self.imageSlider.contentMode = .scaleAspectFit
        self.imageSlider.contentScaleMode = .scaleAspectFit
        self.imageSlider.setImageInputs(imagess)
        
    }
    
    
    @IBAction func CopyLink(_ sender: Any) {
        if let url = self.posts[0]["url"] as? String{
            UIPasteboard.general.string = url
            self.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
        }
    }
    
    @IBAction func SaveImage(_ sender: Any) {
UIImageWriteToSavedPhotosAlbum((self.imageSlider.currentSlideshowItem?.imageView.image)!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @IBAction func Comments(_ sender: Any) {
        let vc = Storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentController
        
        if let count = self.reactions["count"] as? Int{
            vc.likes = count
        }
        vc.postId = self.postid
        vc.comments = self.comments
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Share(_ sender: Any) {
        let vc = Storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func More(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        if let is_saved = self.posts[0]["is_post_saved"] as? Bool{
            if !is_saved{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Save Post", comment: "Save Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.posts[0]["is_post_saved"] = true
                        SavePostManager.sharedInstance.savedPost(targetController: self, postId: self.postid ?? "", action: "save")
                    }
                }))
            }
            else{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Unsave Post", comment: "Unsave Post"), style: .default, handler: { (_) in
                    let status = Reach().connectionStatus()
                    switch status {
                    case .unknown, .offline:
                        self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                    case .online(.wwan), .online(.wiFi):
                        self.posts[0]["is_post_saved"] = false
                        SavePostManager.sharedInstance.savedPost(targetController: self, postId: self.postid ?? "", action: "save")
                    }
                }))
            }
        }
        if let copyText = self.posts[0]["postText"] as? String{
            if copyText != ""{
                alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Text", comment: "Copy Text"), style: .default, handler: { (_) in
                    UIPasteboard.general.string = copyText
                    self.view.makeToast(NSLocalizedString("Text copied to clipboard", comment: "Text copied to clipboard"))
                }))
            }
        }
        if let copyLink = self.posts[0]["url"] as? String{
            alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Link", comment: "Copy Link"), style: .default, handler: { (_) in
                UIPasteboard.general.string = copyLink
                self.view.makeToast(NSLocalizedString("Link copied to clipboard", comment: "Link copied to clipboard"))
            }))
        }
        if let publisher = self.posts[0]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost != UserData.getUSER_ID(){
                    if let is_report = self.posts[0]["is_post_reported"] as? Bool{
                        if !is_report{
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Report Post", comment: "Report Post"), style: .default, handler: { (_) in
                                let status = Reach().connectionStatus()
                                switch status {
                                case .unknown, .offline:
                                    self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
                                case .online(.wwan), .online(.wiFi):
                                    ReportPostManager.sharedInstance.reportedPost(targetController: self, postId: self.postid ?? "")
                                }
                            }))
                        }
                    }
                }
            }
        }
        if let publisher = self.posts[0]["publisher"] as? [String:Any]{
            if let is_myPost = publisher["user_id"] as? String{
                if is_myPost == UserData.getUSER_ID(){
                    //                alert.addAction(UIAlertAction(title: "Edit Post", style: .default, handler: { (_) in
                    //                }))
                    //                alert.addAction(UIAlertAction(title: "Boost Post", style: .default, handler: { (_) in
                    //                }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Delete Post", comment: "Delete Post"), style: .default, handler: { (_) in
                        DeletePostManager.sharedInstance.postDelete(targetController: self,   postId: self.postid ?? "") { (success) in
                            if AppInstance.instance.vc == "myProfile"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "newsFeedVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performSegue"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "popularPostVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "hasTagPostVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "savedPostVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "showPostVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "eventDetailVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "pageVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifire"), object: nil, userInfo: userInfo)
                            }
                            else if AppInstance.instance.vc == "groupVC"{
                                let userInfo = ["userData":self.selectedIndex,"type":"delete"] as [String : Any]
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
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            self.view.makeToast(error.localizedDescription)
            //               showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            self.view.makeToast("Image Saved")
        }
    }
    
    
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            if let is_reated = self.reactions["is_reacted"] as? Bool{
                if is_reated{
                    let count = self.likesCountLabel.text
                    self.likesCountLabel.text = "\((Int(count ?? "0") ?? 0) - 1)"
                    self.LikeBtn.setImage(UIImage(named: "like"), for: .normal)
                    self.LikeBtn.setTitle("  Like", for: .normal)
                    self.LikeBtn.setTitleColor(.lightGray, for: .normal)
                    self.reactions["is_reacted"] = false
                    self.reaction(reaction: "")
                }
                else{
                    let count = self.likesCountLabel.text
                    self.likesCountLabel.text = "\((Int(count ?? "0") ?? 0) + 1)"
                    self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                    self.LikeBtn.setTitle("   Like", for: .normal)
                    self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                    self.reactions["is_reacted"] = true
                    self.reaction(reaction: "1")
                }
            }
        }
    }
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        let vc = Storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func addReaction(reation: String) {
        let count = self.likesCountLabel.text
        if let is_reated = self.reactions["is_reacted"] as? Bool{
            if !is_reated{
                self.likesCountLabel.text = "\((Int(count ?? "0") ?? 0) + 1)"
            }
        }
        self.reaction(reaction: reation)
        self.reactions["is_reacted"] = true
        if reation == "1"{
            self.LikeBtn.setImage(UIImage(named: "like-2"), for: .normal)
            self.LikeBtn.setTitle("   Like", for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            self.LikeBtn.setImage(UIImage(named: "love"), for: .normal)
            self.LikeBtn.setTitle("   Love", for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
        }
        else if reation == "3"{
            self.LikeBtn.setImage(UIImage(named: "haha"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("   Haha", for: .normal)
        }
        else if reation == "4"{
            self.LikeBtn.setImage(UIImage(named: "wow"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("   Wow", for: .normal)
        }
        else if reation == "5"{
            self.LikeBtn.setImage(UIImage(named: "sad"), for: .normal)
            self.LikeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.LikeBtn.setTitle("   Sad", for: .normal)
        }
        else {
            self.LikeBtn.setImage(UIImage(named: "angry"), for: .normal)
            self.LikeBtn.setTitle("   Angry", for: .normal)
            self.LikeBtn.setTitleColor(.red, for: .normal)
        }
    }
    func sharePost() {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts =  [self.posts[0]]
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func sharePostTo(type: String) {
        if (type == "group") || (type == "page"){
            let Storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier : "MyGroups&PagesVC") as! MyGroupsandMyPagesController
            vc.type = type
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = Storyboard.instantiateViewController(withIdentifier : "SharePopUpVC") as! SharePopUpController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func sharePostLink() {
        var text = ""
        if let postUrl =  self.posts[0]["url"] as? String{
            text = postUrl
        }
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func selectPageandGroup(data: [String : Any], type: String) {
        let vc = Storyboard.instantiateViewController(withIdentifier : "SharePostVC") as! SharePostController
        vc.posts =  [self.posts[0]]
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
        self.present(vc, animated: true, completion: nil)
    }
    
    private func reaction(reaction: String){
        performUIUpdatesOnMain {
            AddReactionManager.sharedInstance.addReaction(postId: self.postid ?? "", reaction: reaction) { (success, authError, error) in
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
}
