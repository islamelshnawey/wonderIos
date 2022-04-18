//
//  UserProfileController.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/16/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage
import WoWonderTimelineSDK
import Async
import DropDown

class UserProfileController: BaseVC {
    
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var follwoingCount: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followBtn: RoundButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var addBtn: RoundButton!
    var userData : FollowingModel.Following?
    var user_data: GetUserDataModel.UserData?
    private let moreDropdown = DropDown()
    var admin = ""
    var isFollowing = 1
    var recipient_ID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeDropdown()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        self.followersLabel.text = NSLocalizedString("Followers", comment: "Followers")
        self.followingLabel.text = NSLocalizedString("Following", comment: "Following")
        self.userInfoLabel.text = NSLocalizedString("Social Link", comment: "Social Link")
        let cover = userData?.cover
        let url = URL(string: cover ?? "")
        self.coverImage.sd_setImage(with: url, placeholderImage: UIImage(named: "d-cover"), options: [], completed: nil)
        let profile = userData?.avatar
        let pro_url = URL(string: profile ?? "")
        self.profileImage.sd_setImage(with: pro_url, placeholderImage: UIImage(named: "d-avatar"), options: [], completed: nil)
        self.profileName.text = self.userData?.name
        self.admin = self.userData?.admin ?? ""
        self.userName.text = "\("@")\(self.userData?.username ?? "")"
        if self.userData?.gender == "male"{
            self.genderLabel.text = "Male"
        }
        else{
            self.genderLabel.text = "Female"
        }
        //        self.genderLabel.text = self.userData?.gender ?? ""
        if userData?.status == "0"{
            self.statusLabel.text = ControlSettings.WoWonderText
        }
        else{
            self.statusLabel.text = userData?.status
        }
        if self.userData?.isFollowing == 1{
            self.followBtn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
            
        }
        else if (self.userData?.isFollowing == 2){
            self.followBtn.setImage(UIImage(named: "log-in-1"), for: .normal)
            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
        }
        else{
            self.followBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "888787")
        }
        self.showProgressDialog(text: "Loading...")
        if self.isFollowing == 1{
            self.getUserData(user_ID: self.userData?.userID ?? "")
        }
        else{
            self.getUserData(user_ID: self.recipient_ID ??  "")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func getUserData(user_ID: String){
        if Connectivity.isConnectedToNetwork(){
            GetUserDataManager.instance.getUserData(user_id: user_ID, session_Token: AppInstance.instance.sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
                if success != nil {
                    Async.main({
                        self.dismissProgressDialog {
                            self.user_data = success?.userData
                            self.admin = self.user_data?.admin ?? ""
                            self.follwoingCount.text = self.user_data?.details?.followingCount ?? "0"
                            self.followersCount.text = self.user_data?.details?.followersCount ?? "0"
                            if self.user_data?.isFollowing == 1{
                                self.followBtn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                                self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                            }
                            else if (self.user_data?.isFollowing == 2){
                                self.followBtn.setImage(UIImage(named: "log-in-1"), for: .normal)
                                self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                            }
                            else{
                                self.followBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                                self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "888787")
                            }
                            
                            let cover = self.user_data?.cover
                            let url = URL(string: cover ?? "")
                            self.coverImage.sd_setImage(with: url, placeholderImage: UIImage(named: "d-cover"), options: [], completed: nil)
                            let profile = self.user_data?.avatar
                            let pro_url = URL(string: profile ?? "")
                            self.profileImage.sd_setImage(with: pro_url, placeholderImage: UIImage(named: "d-avatar"), options: [], completed: nil)
                            self.profileName.text = self.user_data?.name
                            self.admin = self.user_data?.admin ?? ""
                            self.userName.text = "\("@")\(self.user_data?.username ?? "")"
                            if self.user_data?.gender == "male"{
                                self.genderLabel.text = "Male"
                            }
                            else{
                                self.genderLabel.text = "Female"
                            }
                            //        self.genderLabel.text = self.userData?.gender ?? ""
                            if self.user_data?.status == "0"{
                                self.statusLabel.text = ControlSettings.WoWonderText
                            }
                            else{
                                self.statusLabel.text = self.user_data?.status
                            }
                            
                        }
                    })
                }
                else if sessionError != nil{
                    Async.main({
                        
                        self.dismissProgressDialog {
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText)
                        }
                    })
                }
                else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("serverError = \(serverError?.errors?.errorText)")
                            self.view.makeToast(serverError?.errors?.errorText)
                        }
                    })
                }
                else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription)
                        }
                    })
                }
            }
        }
        else{
            self.dismissProgressDialog {
                //                let securityAlertVC = R.storyboard.main.securityPopupVC()
                //                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                //                securityAlertVC?.errorText = InterNetError ?? ""
                //                self.present(securityAlertVC!, animated: true, completion: nil)
                //                log.error("internetError - \(InterNetError)")
                self.view.makeToast(NSLocalizedString("Internet Error", comment: "Internet Error"))
            }
        }
    }
    private func  followRequest(){
        if Connectivity.isConnectedToNetwork(){
            Async.main({
                
                FollowingManager.instance.followUnfollow(user_id: self.user_data?.userID ?? "", session_Token: AppInstance.instance.sessionId ?? "", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.followStatus ?? "")")
                                self.view.makeToast(success?.followStatus ?? "")
                                if success?.followStatus  ?? "" == "followed"{
                                    self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                                    if (AppInstance.instance.connectivity_setting == "0"){
                                        self.followBtn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                                        self.view.makeToast(success?.followStatus ?? "")
                                        self.user_data?.isFollowing = 1
                                    }
                                    else{
                                        if (self.user_data?.isFollowing == 0){
                                            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                                            self.user_data?.isFollowing = 2
                                            self.followBtn.setImage(#imageLiteral(resourceName: "log-in-1"), for: .normal)
                                            self.view.makeToast(NSLocalizedString("Requested", comment: "Requested"))
                                            
                                            
                                        }
                                        else{
                                            self.user_data?.isFollowing = 1
                                            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                                            self.followBtn.setTitle(NSLocalizedString("MyFriend", comment: "MyFriend"), for: .normal)
                                            self.followBtn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                                        }
                                    }
                                    
                                    
                                    //                                    self.followBtn.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
                                    //                                    self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "984243")
                                    //                                    self.view.makeToast(success?.followStatus ?? "")
                                    
                                }else{
                                    if (AppInstance.instance.connectivity_setting == "0"){
                                        self.user_data?.isFollowing = 0
                                        self.followBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                                        self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "888787")
                                        self.view.makeToast(success?.followStatus ?? "")
                                    }
                                    else{
                                        self.user_data?.isFollowing = 0
                                        self.followBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                                        self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "888787")
                                        self.view.makeToast(success?.followStatus ?? "")
                                    }
                                    //////////
                                    //                                    self.followBtn.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                                    //                                    self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "888787")
                                    //                                    self.view.makeToast(success?.followStatus ?? "")
                                }
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else if serverError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(serverError?.errors?.errorText)
                                log.error("serverError = \(serverError?.errors?.errorText)")
                            }
                            
                        })
                        
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                })
            })
        }
        else{
            self.dismissProgressDialog {
                //                let securityAlertVC = R.storyboard.main.securityPopupVC()
                //                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                //                securityAlertVC?.errorText = InterNetError ?? ""
                //                self.present(securityAlertVC!, animated: true, completion: nil)
                //                log.error("internetError - \(InterNetError)")
                self.view.makeToast(NSLocalizedString("Internet Error", comment: "Internet Error"))
            }
        }
    }
    
    
    private func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Block", comment: "Block"),NSLocalizedString("Copy Link To Profile", comment: "Copy Link To Profile"), NSLocalizedString("Share", comment: "Share")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.blockUser()
            }else if index == 1{
                UIPasteboard.general.string = self.user_data?.url ?? ""
                self.view.makeToast(NSLocalizedString("Copied to clipboard", comment: "Copied to clipboard"))
            }else if index == 2{
                let textToShare = [ self.user_data?.url ?? "" ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.message,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.init(rawValue: "net.whatsapp.WhatsApp.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.google.Gmail.ShareExtension"),UIActivity.ActivityType.init(rawValue: "com.toyopagroup.picaboo.share"),UIActivity.ActivityType.init(rawValue: "com.tinyspeck.chatlyio.share")]
                self.present(activityViewController, animated: true, completion: nil)
                
            }
            print("Index = \(index)")
        }
        
    }
    
    
    private func blockUser(){
        if self.admin == "1"{
            let alert = UIAlertController(title: "", message: NSLocalizedString("You cannot block this user because it is administrator", comment: "You cannot block this user because it is administrator"), preferredStyle: .alert)
            let okay = UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion:nil)
        }else{
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let sessionToken = AppInstance.instance.sessionId ?? ""
            Async.background({
                BlockUsersManager1.instanc.blockUnblockUser(session_Token: sessionToken, blockTo_userId: self.user_data?.userID ?? "", block_Action: "block", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.blockStatus ?? "")")
                                self.view.makeToast(NSLocalizedString("User has been unblocked!!", comment: "User has been unblocked!!"))
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.errors?.errorText)
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                
                            }
                        })
                    }else if serverError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(serverError?.errors?.errorText)
                                log.error("serverError = \(serverError?.errors?.errorText)")
                            }
                            
                        })
                        
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription)
                                log.error("error = \(error?.localizedDescription)")
                            }
                        })
                    }
                    
                })
                
            })
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func More(_ sender: Any) {
        self.moreDropdown.show()
    }
    
    @IBAction func Message(_ sender: Any) {
        if self.isFollowing == 1{
            let chatColor = UserDefaults.standard.getChatColorHex(Key: Local.CHAT_COLOR_HEX.ChatColorHex)
            let vc = R.storyboard.chat.chatScreenVC()
            vc?.recipientID = self.userData?.userID
            vc!.followingUserObject = self.userData! ?? nil
            vc?.chatColorHex = chatColor
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func Add(_ sender: Any) {
        self.followRequest()
    }
    
    @IBAction func socialLink(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            if self.user_data?.facebook != ""{
                let appURL = URL(string: self.user_data?.facebook ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.facebook ?? "")
                    application.open(webURL!)
                }
            }
        case 1:
            if (self.user_data?.instagram != ""){
                let appURL = URL(string: self.user_data?.instagram ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.instagram ?? "")
                    application.open(webURL!)
                }
            }
        case 2:
            if (self.user_data?.twitter != ""){
                let appURL = URL(string: self.user_data?.twitter ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.twitter ?? "")
                    application.open(webURL!)
                }
            }
        case 3:
            if (self.user_data?.google != ""){
                let appURL = URL(string: self.user_data?.google ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.google ?? "")
                    application.open(webURL!)
                }
            }
        case 4:
            if (self.user_data?.vk != ""){
                let appURL = URL(string: self.user_data?.vk ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.vk ?? "")
                    application.open(webURL!)
                }
            }
        case 5:
            if (self.user_data?.youtube != ""){
                let appURL = URL(string: self.user_data?.youtube ?? "")
                let application = UIApplication.shared
                if application.canOpenURL(appURL!) {
                    application.open(appURL!)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: self.user_data?.youtube ?? "")
                    application.open(webURL!)
                }
            }
            
        default:
            print("Nothing")
        }
    }
    
    
    
}
