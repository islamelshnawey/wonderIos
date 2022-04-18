

import UIKit
import Async
import SwiftEventBus
import DropDown
import AVFoundation
import AVKit
import GoogleMaps
import ActionSheetPicker_3_0
import WoWonderTimelineSDK

class ChatScreenVC: BaseVC {
    @IBOutlet weak var cancelPressed: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var replyUsernameLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    //For audio messages
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var myaudioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var replyInView: UIView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var showAudioCancelBtn: UIButton!
    @IBOutlet weak var showAudioPlayBtn: UIButton!
    @IBOutlet weak var showAudioView: UIView!
    @IBOutlet weak var microBtn: UIButton!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    @IBOutlet weak var replyTextLabel: UILabel!
    
    
    
    
    var count = 0
    var isFistTry = true
    var audioDuration = ""
    
    //For template msg
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TempMsgCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    var index:Int? = 0
    var userObject:GetUserListModel.Datum?
    var searchUserObject:SearchModel.User?
    var followingUserObject:FollowingModel.Following?
    var recipientID:String? = ""
    var audioPlayer = AVAudioPlayer()
    var chatColorHex:String? = ""
    private var messagesArray = [UserChatModel.Message]()
    private var stopArray = [UserChatModel.Message]()
    private var userChatCount:Int? = 0
    private var player = AVPlayer()
    private var playerItem:AVPlayerItem!
    private var playerController = AVPlayerViewController()
    private let moreDropdown = DropDown()
    private let imagePickerController = UIImagePickerController()
    private let MKColorPicker = ColorPickerViewController()
    private var sendMessageAudioPlayer: AVAudioPlayer?
    private var receiveMessageAudioPlayer: AVAudioPlayer?
    private var toneStatus: Bool? = false
    private var scrollStatus:Bool? = true
    private var isReplyStatus:Bool? = false
    private var messageCount:Int? = 0
    private var admin:String? = ""
    private var replyMessageID:String? = ""
    private let chatColors = [
        UIColor.hexStringToUIColor(hex: "#a84849"),
        UIColor.hexStringToUIColor(hex: "#a84849"),
        UIColor.hexStringToUIColor(hex: "#0ba05d"),
        UIColor.hexStringToUIColor(hex: "#609b41"),
        UIColor.hexStringToUIColor(hex: "#8ec96c"),
        UIColor.hexStringToUIColor(hex: "#51bcbc"),
        UIColor.hexStringToUIColor(hex: "#b582af"),
        UIColor.hexStringToUIColor(hex: "#01a5a5"),
        UIColor.hexStringToUIColor(hex: "#ed9e6a"),
        UIColor.hexStringToUIColor(hex: "#aa2294"),
        UIColor.hexStringToUIColor(hex: "#f33d4c"),
        UIColor.hexStringToUIColor(hex: "#a085e2"),
        UIColor.hexStringToUIColor(hex: "#ff72d2"),
        UIColor.hexStringToUIColor(hex: "#056bba"),
        UIColor.hexStringToUIColor(hex: "#f9c270"),
        UIColor.hexStringToUIColor(hex: "#fc9cde"),
        UIColor.hexStringToUIColor(hex: "#0e71ea"),
        UIColor.hexStringToUIColor(hex: "#008484"),
        UIColor.hexStringToUIColor(hex: "#c9605e"),
        UIColor.hexStringToUIColor(hex: "#5462a5"),
        UIColor.hexStringToUIColor(hex: "#2b87ce"),
        UIColor.hexStringToUIColor(hex: "#f2812b"),
        UIColor.hexStringToUIColor(hex: "#f9a722"),
        UIColor.hexStringToUIColor(hex: "#56c4c5"),
        UIColor.hexStringToUIColor(hex: "#70a0e0"),
        UIColor.hexStringToUIColor(hex: "#a1ce79")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.textViewPlaceHolder()
        self.customizeDropdown()
        self.fetchData()
        self.fetchUserProfile()
        //Turn this on for audio messageing
        //self.setupAudioMessageConfig(
        self.tableView.register(UINib(nibName: "ProductTableCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        MKColorPicker.allColors = chatColors
        MKColorPicker.selectedColor = { color in
            
            log.verbose("selected Color = \(color.toHexString())")
            UserDefaults.standard.setChatColorHex(value: color.toHexString(), ForKey: Local.CHAT_COLOR_HEX.ChatColorHex)
            self.topView.backgroundColor = color ?? UIColor.hexStringToUIColor(hex: "#a84849")
            self.statusBarView.backgroundColor = color ?? UIColor.hexStringToUIColor(hex: "#a84849")
            self.sendBtn.backgroundColor = color
            self.changeChatColor(colorHexString: color.toHexString())
            self.chatColorHex = color.toHexString()
            self.tableView.reloadData()
            
        }
        log.verbose("recipientID = \(recipientID)")
        
        let messageTextFrame = self.messageTxtView.frame.height / 3
        self.messageTxtView.textContainerInset = UIEdgeInsets(top: messageTextFrame, left: 13, bottom: messageTextFrame, right: 13)
        messageTxtView.delegate = self
      
       
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.heightConstraint.constant = 0
        self.cancelPressed.isHidden = true
        self.replyUsernameLabel.text = self.usernameLabel.text
        self.replyUsernameLabel.isHidden = true
        self.replyTextLabel.isHidden = true
        self.replyInView.isHidden = true
        self.sideView.isHidden = true
                SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
                    self.fetchData()
        
                }
                SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
                    log.verbose("Internet dis connected!")
                }
        if ControlSettings.socketChat{
            let joinData = [
                "username":AppInstance.instance.userProfile?.username ?? "",
                "user_id":AppInstance.instance.sessionId ?? "",
                "recipient_ids":[
                    self.recipientID ?? ""
                
                ]
            ] as [String : Any]
          //  SocketIOManager.sharedInstance.sendJoin(message: SocketEvents.SocketEventconstantsUtils.EVENT_JOIN, username: user, userID: <#T##String#>)
          //  SocketIOManager.sharedInstance.sendJoin(message: "join", withNickname: joinData)
            let data  =
                [
                    "recipient_id":self.recipientID ?? "",
                    "user_id":AppInstance.instance.sessionId ?? "",
                    "current_user_id":AppInstance.instance.userId ?? ""
                ] as [String : Any]
            SocketIOManager.sharedInstance.sendSeenMessage(message: SocketEvents.SocketEventconstantsUtils.EVENT_SEEN_MESSAGE, recipentID: self.recipientID ?? "", userID: AppInstance.instance.sessionId ?? "", currentUserID: AppInstance.instance.userId ?? "")
            self.getMessage()
        }else{
                    let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        SocketIOManager.sharedInstance.onTyping { data in
            let isTyping = data["is_typing"] as? Int
            if  isTyping == 200{
                self.lastSeenLabel.text = "Typing"
            }else{
                self.lastSeenLabel.text = "\(NSLocalizedString("last seen", comment: "last seen"))\(" ")\( self.setTimestamp(epochTime: (self.userObject?.lastseen  ?? "") ?? "") ?? self.setTimestamp(epochTime: (self.searchUserObject?.lastseen  ?? "") ?? "")   ?? self.setTimestamp(epochTime: (self.followingUserObject?.lastseen ?? "") ?? "")  ?? "")"
            }
        }
    }
    
    
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    @objc func update() {
        self.fetchData()
        
        
    }
    private func getMessage(){
        SocketIOManager.sharedInstance.getChatMessage { data in
          let userID = data["id"] as? String
            let receiver = data["receiver"] as? String
            let sender = data["sender"] as? Int
            var type = ""
            if sender == Int(AppInstance.instance.userId ?? "0"){
                type = "right_text"
            }else if receiver == AppInstance.instance.userId ?? "0"{
                type = "left_text"
            }else if sender == Int(AppInstance.instance.userId ?? "0") && receiver == AppInstance.instance.userId ?? "0"{
                type = "right_text"
            }
            log.verbose("show message = \(data["message"] as? String)")
            let oject = UserChatModel.Message(id: data["id"] as? String, fromID: "", groupID:  "", pageID: "", toID: "", text: data["message"] as? String, media: "", mediaFileName: "", mediaFileNames: "", time: data["time_api"] as? String, seen:  "", deletedOne:  "", deletedTwo:  "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID:"", lat:data["lat"] as? String, lng: data["lng"] as? String, replyID: "", storyID:  "", broadcastID: "", forward: "", reply: nil, pin: "", timeText:  "", position: "", type: type, product: nil, fileSize: 0)
            self.messagesArray.append(oject)
            self.tableView.reloadData()
            if self.scrollStatus!{
                if self.messagesArray.count == 0{
                    self.setTemplateMessage()
                    log.verbose("Will not scroll more")
                }else{
                    self.collectionView.removeFromSuperview()
                    self.scrollStatus = false
                    self.messageCount = self.messagesArray.count ?? 0
                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }else{
                if self.messagesArray.count > self.messageCount!{
                    if self.toneStatus!{
                        self.playReceiveMessageSound()
                    }else{
                        log.verbose("To play sound please enable conversation tone from settings..")
                    }
                    self.messageCount = self.messagesArray.count ?? 0
                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                }else{
                    log.verbose("Will not scroll more")
                }
                log.verbose("Will not scroll more")
            }
        }
    }
    func convertDate(Unix:Double) -> Date{
        let timestamp = Unix
        
        var dateFromTimeStamp = Date(timeIntervalSinceNow: timestamp as! TimeInterval / 1000)
        return dateFromTimeStamp
        
    }
    func setTimestamp(epochTime: String) -> String {
           let currentDate = Date()
           
           let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
           
           let calendar = Calendar.current
           
           let currentDay = calendar.component(.day, from: currentDate)
           let currentHour = calendar.component(.hour, from: currentDate)
           let currentMinutes = calendar.component(.minute, from: currentDate)
           let currentSeconds = calendar.component(.second, from: currentDate)
           
           let epochDay = calendar.component(.day, from: epochDate)
           let epochMonth = calendar.component(.month, from: epochDate)
           let epochYear = calendar.component(.year, from: epochDate)
           let epochHour = calendar.component(.hour, from: epochDate)
           let epochMinutes = calendar.component(.minute, from: epochDate)
           let epochSeconds = calendar.component(.second, from: epochDate)
           
           if (currentDay - epochDay < 30) {
               if (currentDay == epochDay) {
                   if (currentHour - epochHour == 0) {
                       if (currentMinutes - epochMinutes == 0) {
                           if (currentSeconds - epochSeconds <= 1) {
                               return String(currentSeconds - epochSeconds) + " second ago"
                           } else {
                               return String(currentSeconds - epochSeconds) + " seconds ago"
                           }
                           
                       } else if (currentMinutes - epochMinutes <= 1) {
                           return String(currentMinutes - epochMinutes) + " minute ago"
                       } else {
                           return String(currentMinutes - epochMinutes) + " minutes ago"
                       }
                   } else if (currentHour - epochHour <= 1) {
                       return String(currentHour - epochHour) + " hour ago"
                   } else {
                       return String(currentHour - epochHour) + " hours ago"
                   }
               } else if (currentDay - epochDay <= 1) {
                   return String(currentDay - epochDay) + " day ago"
               } else {
                   return String(currentDay - epochDay) + " days ago"
               }
           } else {
               return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
           }
       }
    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    private func setupTapOnUsernameToViewProfile(){
        //For profile
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatScreenVC.showProfile))
        usernameLabel.isUserInteractionEnabled = true
        lastSeenLabel.isUserInteractionEnabled = true
        lastSeenLabel.addGestureRecognizer(tap)
        usernameLabel.addGestureRecognizer(tap)
    }
    
    @IBAction func showProfile(sender: UITapGestureRecognizer) {
        self.navigateToUserProfile()
    }
    
    private func navigateToUserProfile(){
        let vc = R.storyboard.dashboard.userProfileVC()
        print(self.recipientID)
        vc?.isFollowing = 0
        vc?.recipient_ID = self.recipientID ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        SwiftEventBus.unregister(self)
    }
    
    @objc override func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        //Check the device height
        bottomConstraint?.constant = (keyboardFrame!.height + (UIScreen.main.nativeBounds.height >= 2436 ? 80 : 100))
        animatedKeyBoard(scrollToBottom: true)
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        bottomConstraint?.constant = 100
        animatedKeyBoard(scrollToBottom: false)
    }
    
    fileprivate func animatedKeyBoard(scrollToBottom: Bool) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            if scrollToBottom {
                self.view.layoutIfNeeded()
            }
        }, completion: { (completed) in
            if scrollToBottom {
                if !self.messagesArray.isEmpty {
                    let indexPath = IndexPath(item: self.messagesArray.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        })
    }
    
    @IBAction func callPressed(_ sender: Any) {
        let vc = R.storyboard.call.agoraCallNotificationPopupVC()
        vc?.callingType = "calling..."
        vc?.callingStatus = "audio"
        if userObject != nil{
            vc?.callUserObject = userObject
        }else if searchUserObject != nil{
            vc?.searchUserObject =  searchUserObject
        }else{
            vc?.followingUserObject =  followingUserObject
        }
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func videoCallPressed(_ sender: Any) {
        let vc = R.storyboard.call.agoraCallNotificationPopupVC()
        vc?.callingType = "calling Video..."
        vc?.callingStatus = "video"
        vc?.delegate = self
        if userObject != nil{
            vc?.callUserObject = userObject
        }else if searchUserObject != nil{
            vc?.searchUserObject =  searchUserObject
        }else{
            vc?.followingUserObject =  followingUserObject
        }
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func pickColorPressed(_ sender: UIButton) {
        
        if let popoverController = MKColorPicker.popoverPresentationController{
            popoverController.delegate = MKColorPicker
            popoverController.permittedArrowDirections = .any
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(MKColorPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func selectVideoPressed(_ sender: Any) {
        openVideoGallery()
    }
    
    @IBAction func contactPressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.inviteFriendsVC()
        vc?.status = true
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    @IBAction func selectPhotoPressed(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Upload", rows: ["camera", "gallery"], initialSelection: 0, doneBlock: { (picker, index, values) in
            
            if index == 0{
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            
            return
            
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func microPressed(_ sender: Any) {
    }
    
    @IBAction func selectFilePressed(_ sender: Any) {
        
        //        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        //
        //
        //        documentPicker.delegate = self
        //        present(documentPicker, animated: true, completion: nil)
        let alert = UIAlertController(title:NSLocalizedString("Select what you want", comment: "Select what you want"), message: "", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: NSLocalizedString("Image Gallery", comment: "Image Gallery"), style: .default) { (action) in
            log.verbose("Image Gallery")
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: NSLocalizedString("Take a picture from the camera", comment: "Take a picture from the camera"), style: .default) { (action) in
            log.verbose("Take a picture from the camera")
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let video = UIAlertAction(title: NSLocalizedString("Video Gallery", comment: "Video Gallery"), style: .default) { (action) in
            log.verbose("Video Gallery")
            self.openVideoGallery()
        }
        
        let location = UIAlertAction(title: NSLocalizedString("Location", comment: "Location"), style: .default) { (action) in
            log.verbose("Location")
            let vc = R.storyboard.chat.locationVC()
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let contact = UIAlertAction(title: NSLocalizedString("Contact", comment: "Contact"), style: .default) { (action) in
            let vc = R.storyboard.dashboard.inviteFriendsVC()
            vc?.status = true
            vc?.delegate = self
            self.present(vc!, animated: true, completion: nil)
        }
        
        let file = UIAlertAction(title: NSLocalizedString("File", comment: "File"), style: .default) { (action) in
            log.verbose("File")
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let gif = UIAlertAction(title: NSLocalizedString("Gif", comment: "Gif"), style: .default) { (action) in
            log.verbose("Gif")
            let vc = R.storyboard.chat.gifVC()
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(video)
        alert.addAction(location)
        alert.addAction(file)
        alert.addAction(gif)
        alert.addAction(contact)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if self.messageTxtView.text == NSLocalizedString("Your message here...", comment: "Your message here..."){
            log.verbose("will not send message as it is PlaceHolder...")
        }else{
            if messageTxtView.text!.isEmpty {
                log.verbose("will not send message as it is PlaceHolder...")
            }else{
                self.sendMessage(messageText:  messageTxtView.text ?? "", lat: 0, long: 0, socketCheck: ControlSettings.socketChat)
                self.messageTxtView.text = ""
            }
        }
    }
    
    @IBAction func morePressed(_ sender: Any) {
        self.moreDropdown.show()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        SwiftEventBus.unregister(self)
        
        
    }
    func fetchUserProfile(){
        let status = AppInstance.instance.getUserSession()
        if status{
            let recipientID =  self.recipientID ?? ""
            let sessionId = AppInstance.instance.sessionId ?? ""
            Async.background({
                GetUserDataManager.instance.getUserData(user_id: recipientID , session_Token: sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            log.debug("success = \(success?.userData)")
                            self.admin = success?.userData?.admin ?? ""
                            log.verbose("Admin = \(self.admin)")
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        })
                    }else if serverError != nil{
                        Async.main({
                            
                            log.error("serverError = \(serverError?.errors?.errorText)")
                            
                            
                        })
                        
                    }else {
                        Async.main({
                            log.error("error = \(error?.localizedDescription)")
                        })
                    }
                }
            })
        }else {
            log.error(InterNetError)
            
            
        }
        
    }
    fileprivate func setTemplateMessage() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: -15).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func fetchData(){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            ChatManager.instance.getUserChats(user_id: userId, session_Token: sessionID, receipent_id: self.recipientID ?? "", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.messagesArray.removeAll()
                            var imagesArray = [UserChatModel.Image]()
                            guard let messages = success?["messages"] as? [[String:Any]] else {return }
                            log.debug("userList = \(messages.count ?? 0)")
                            for item in stride(from: (messages.count) - 1, to: -1, by: -1){
                                let product = messages[item]["product"] as? [String:Any]
                                let images = product?["images"] as? [[String:Any]]
                                images?.forEach { item in
                                    let object =  UserChatModel.Image(id: item["id"] as? String, image: item["image"] as? String, productID: item["product_id"] as? String, imageOrg: item["image_org"] as? String)
                                    imagesArray.append(object)
                                }
                                var reply = messages[item]["reply"] as? [String:Any]
                                var replyModel : UserChatModel.repltMessage?
                                if reply?.isEmpty ?? false{
                                    log.verbose("reply is empty")
                                }else{
                                    replyModel = UserChatModel.repltMessage(id: reply?["id"] as? String, fromID:reply?["from_id"] as? String, groupID:  reply?["group_id"] as? String, pageID: reply?["page_id"] as? String, toID: reply?["to_id"] as? String, text: reply?["text"] as? String, media: reply?["media"] as? String, mediaFileName:reply?["mediaFileName"] as? String, mediaFileNames: reply?["mediaFileNames"] as? String, time:  reply?["time"] as? String, seen:  reply?["seen"] as? String, deletedOne:  reply?["deleted_one"] as? String, deletedTwo:  reply?["deleted_two"] as? String, sentPush:reply?["sent_push"] as? String, notificationID: reply?["notification_id"] as? String, typeTwo: reply?["type_two"] as? String, stickers: reply?["stickers"] as? String, productID: reply?["product_id"] as? String, lat: reply?["lat"] as? String, lng: reply?["lng"] as? String, replyID:  reply?["reply_id"] as? String, storyID:  reply?["story_id"] as? String, broadcastID: reply?["broadcast_id"] as? String, forward: reply?["forward"] as? String, pin: reply?["pin"] as? String, timeText:  reply?["time_text"] as? String, position: reply?["position"] as? String, type: reply?["type"] as? String, product: .init(id: product?["id"] as? String, userID: product?["user_id"] as? String, pageID: product?["page_id"] as? String, name: product?["name"] as? String, productDescription: product?["productDescription"] as? String, category:  product?["category"] as? String, subCategory: product?["subCategory"] as? String, price: product?["price"] as? String, location: product?["location"] as? String, status: product?["status"] as? String, type: product?["type"] as? String, currency: product?["currency"] as? String, lng: product?["lng"] as? String, lat: product?["lat"] as? String, time: product?["time"] as? String, active: product?["active"] as? String, images: imagesArray, timeText: product?["time_text"] as? String, postID: product?["post_id"] as? String, editDescription: product?["edit_description"] as? String, url: product?["url"] as? String, productSubCategory:  product?["product_sub_category"] as? String, fields: product?["fields"] as? [String]), fileSize: reply?["file_size"] as? Int)
                                }
                                let oject = UserChatModel.Message(id: messages[item]["id"] as? String, fromID: messages[item]["from_id"] as? String, groupID:  messages[item]["group_id"] as? String, pageID: messages[item]["page_id"] as? String, toID: messages[item]["to_id"] as? String, text: messages[item]["text"] as? String, media: messages[item]["media"] as? String, mediaFileName: messages[item]["mediaFileName"] as? String, mediaFileNames: messages[item]["mediaFileNames"] as? String, time:  messages[item]["time"] as? String, seen:  messages[item]["seen"] as? String, deletedOne:  messages[item]["deleted_one"] as? String, deletedTwo:  messages[item]["deleted_two"] as? String, sentPush: messages[item]["sent_push"] as? String, notificationID: messages[item]["notification_id"] as? String, typeTwo: messages[item]["type_two"] as? String, stickers: messages[item]["stickers"] as? String, productID: messages[item]["product_id"] as? String, lat: messages[item]["lat"] as? String, lng: messages[item]["lng"] as? String, replyID:  messages[item]["reply_id"] as? String, storyID:  messages[item]["story_id"] as? String, broadcastID: messages[item]["broadcast_id"] as? String, forward: messages[item]["forward"] as? String, reply: replyModel, pin: messages[item]["pin"] as? String, timeText:  messages[item]["time_text"] as? String, position: messages[item]["position"] as? String, type: messages[item]["type"] as? String, product: .init(id: product?["id"] as? String, userID: product?["user_id"] as? String, pageID: product?["page_id"] as? String, name: product?["name"] as? String, productDescription: product?["productDescription"] as? String, category:  product?["category"] as? String, subCategory: product?["subCategory"] as? String, price: product?["price"] as? String, location: product?["location"] as? String, status: product?["status"] as? String, type: product?["type"] as? String, currency: product?["currency"] as? String, lng: product?["lng"] as? String, lat: product?["lat"] as? String, time: product?["time"] as? String, active: product?["active"] as? String, images: imagesArray, timeText: product?["time_text"] as? String, postID: product?["post_id"] as? String, editDescription: product?["edit_description"] as? String, url: product?["url"] as? String, productSubCategory:  product?["product_sub_category"] as? String, fields: product?["fields"] as? [String]), fileSize: messages[item]["file_size"] as? Int)
                                self.messagesArray.append(oject)
                                
                                
                            }
                            
                            //                            self.messagesArray = success?.messages ?? []
                            //                            success?.messages?.forEach({ (it) in
                            //                                self.messagesArray.append(it)
                            //                            })
                            self.tableView.reloadData()
                            if self.scrollStatus!{
                                
                                if self.messagesArray.count == 0{
                                    self.setTemplateMessage()
                                    log.verbose("Will not scroll more")
                                }else{
                                    self.collectionView.removeFromSuperview()
                                    self.scrollStatus = false
                                    self.messageCount = self.messagesArray.count ?? 0
                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                }
                                
                            }else{
                                if self.messagesArray.count > self.messageCount!{
                                    if self.toneStatus!{
                                        self.playReceiveMessageSound()
                                    }else{
                                        log.verbose("To play sound please enable conversation tone from settings..")
                                    }
                                    self.messageCount = self.messagesArray.count ?? 0
                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                }else{
                                    log.verbose("Will not scroll more")
                                }
                                log.verbose("Will not scroll more")
                                
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
    
    
    func playSendMessageSound() {
        guard let url = Bundle.main.url(forResource: "Popup_SendMesseges", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            sendMessageAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            sendMessageAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = sendMessageAudioPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playReceiveMessageSound() {
        guard let url = Bundle.main.url(forResource: "Popup_GetMesseges", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            receiveMessageAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            receiveMessageAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = receiveMessageAudioPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func sendMessage(messageText: String, lat: Double, long: Double,socketCheck:Bool){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageText
        let recipientId = self.recipientID ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        if socketCheck{
            let data  =
                [
                    "to_id":recipientId,
                    "from_id":sessionID,
                    "username":AppInstance.instance.userProfile?.username ?? "",
                    "msg":messageText,
                    "color":self.chatColorHex ?? "",
                   "isSticker": "false",
                    "message_reply_id" : self.replyMessageID ?? "0"
                ]
            Async.background({
                SocketIOManager.sharedInstance.sendMessage(eventName: SocketEvents.SocketEventconstantsUtils.EVENT_PRIVATE_MESSAGE, toId: recipientId, fromID: sessionID, username: AppInstance.instance.userProfile?.username ?? "", msg: messageText, color: self.chatColorHex ?? "", isSticker: "false", message_reply_id: self.replyMessageID ?? "0") {
                    Async.main({

                        if self.messagesArray.count == 0{
                            if self.isReplyStatus ?? false{
                                let oject = UserChatModel.Message(id:"", fromID: "", groupID:  "", pageID: "", toID: "", text: messageText, media: "", mediaFileName: "", mediaFileNames: "", time:"" , seen:  "", deletedOne:  "", deletedTwo:  "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID:"", lat:"0", lng: "0", replyID: "", storyID:  "", broadcastID: "", forward: "", reply: .init(id: "", fromID: AppInstance.instance.userId ?? "", groupID: "", pageID: "", toID: "", text: self.replyTextLabel.text ?? "", media: "", mediaFileName: "", mediaFileNames: "", time: "", seen: "", deletedOne: "", deletedTwo: "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID: "", lat: "", lng: "", replyID: "", storyID: "", broadcastID: "", forward: "", pin: "", timeText: "", position: "", type: "right_text", product: nil, fileSize: 0), pin: "", timeText:  "", position: "", type:"right_text" , product: nil, fileSize: 0)
                                self.messagesArray.append(oject)
                                self.messageTxtView.text = ""
                                self.heightConstraint.constant = 0
                                self.cancelPressed.isHidden = true
                                self.replyUsernameLabel.isHidden = true
                                self.replyTextLabel.isHidden = true
                                self.replyMessageID = "0"
                                self.isReplyStatus = false
                                self.replyInView.isHidden = true
                                self.sideView.isHidden = true
                            }else{
                                let oject = UserChatModel.Message(id:"", fromID: "", groupID:  "", pageID: "", toID: "", text: messageText, media: "", mediaFileName: "", mediaFileNames: "", time:"" , seen:  "", deletedOne:  "", deletedTwo:  "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID:"", lat:"0", lng: "0", replyID: "", storyID:  "", broadcastID: "", forward: "", reply: nil, pin: "", timeText:  "", position: "", type:"right_text" , product: nil, fileSize: 0)
                                self.messagesArray.append(oject)
                            }
                            self.tableView.reloadData()
                            self.collectionView.removeFromSuperview()
                            self.view.resignFirstResponder()
                        }else{
                            if self.toneStatus!{
                                self.playSendMessageSound()
                            }else{
                                log.verbose("To play sound please enable conversation tone from settings..")
                            }
                            if self.isReplyStatus ?? false{
                                let oject = UserChatModel.Message(id:"", fromID: "", groupID:  "", pageID: "", toID: "", text: messageText, media: "", mediaFileName: "", mediaFileNames: "", time:"" , seen:  "", deletedOne:  "", deletedTwo:  "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID:"", lat:"0", lng: "0", replyID: "", storyID:  "", broadcastID: "", forward: "", reply: .init(id: "", fromID: AppInstance.instance.userId ?? "", groupID: "", pageID: "", toID: "", text: self.replyTextLabel.text ?? "", media: "", mediaFileName: "", mediaFileNames: "", time: "", seen: "", deletedOne: "", deletedTwo: "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID: "", lat: "", lng: "", replyID: "", storyID: "", broadcastID: "", forward: "", pin: "", timeText: "", position: "", type: "right_text", product: nil, fileSize: 0), pin: "", timeText:  "", position: "", type:"right_text" , product: nil, fileSize: 0)
                                self.messagesArray.append(oject)
                                self.messageTxtView.text = ""
                                self.heightConstraint.constant = 0
                                self.cancelPressed.isHidden = true
                                self.replyUsernameLabel.isHidden = true
                                self.replyTextLabel.isHidden = true
                                self.replyMessageID = "0"
                                self.isReplyStatus = false
                                self.replyInView.isHidden = true
                                self.sideView.isHidden = true
                            }else{
                                let oject = UserChatModel.Message(id:"", fromID: "", groupID:  "", pageID: "", toID: "", text: messageText, media: "", mediaFileName: "", mediaFileNames: "", time:"" , seen:  "", deletedOne:  "", deletedTwo:  "", sentPush: "", notificationID: "", typeTwo: "", stickers: "", productID:"", lat:"0", lng: "0", replyID: "", storyID:  "", broadcastID: "", forward: "", reply: nil, pin: "", timeText:  "", position: "", type:"right_text" , product: nil, fileSize: 0)
                                self.messagesArray.append(oject)
                            }
                            self.tableView.reloadData()

            //                SocketIOManager.sharedInstance.onPrivateMessage { data in
            //                    log.verbose("data =\(data)")
            //                }
                            //                                self.textViewPlaceHolder()
                            self.view.resignFirstResponder()
                            //                log.debug("userList = \(success?.messageData ?? [])")
                            let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                        }
                    })
                }
               
            })
        }else{
                    let data1  =
                        [
                            "recipient_id":recipientId,
                            "user_id":sessionID,
                            "current_user_id":AppInstance.instance.userId ?? ""

                        ] as [String : Any]
               //     SocketIOManager.sharedInstance.sendSeenMessage(message: "seen_messages", withNickname: data1)
                    Async.background({
                        ChatManager.instance.sendMessage(message_hash_id: messageHashId, receipent_id: recipientId, text: messageText, session_Token: sessionID, lat: lat, long: long, replyMessageID: self.replyMessageID ?? "", completionBlock: { (success, sessionError, serverError, error) in
                            if success != nil{
                                Async.main({
                                    self.dismissProgressDialog {
                                        if self.messagesArray.count == 0{
                                            log.verbose("Will not scroll more")
                                            //                                self.textViewPlaceHolder()
                                            self.view.resignFirstResponder()
                                        }else{
                                            if self.toneStatus!{
                                                self.playSendMessageSound()
                                            }else{
                                                log.verbose("To play sound please enable conversation tone from settings..")
                                            }
                                            self.messageTxtView.text = ""
                                            let data  =
                                                [
                                                    "recipient_id":recipientId,
                                                    "user_id":sessionID,
                                                    "current_user_id":AppInstance.instance.userId ?? ""
                                                ] as [String : Any]
                                      //      SocketIOManager.sharedInstance.sendSeenMessage(message: "seen_messages", withNickname: data)
            
                                            //                                self.textViewPlaceHolder()
                                            self.view.resignFirstResponder()
                                            log.debug("userList = \(success?.messageData ?? [])")
                                            let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
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
       
        
       
       
    }
    private func deleteChat(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            
            ChatManager.instance.deleteChat(user_id: self.recipientID ?? "", session_Token: sessionID, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                            if ControlSettings.socketChat{
                                self.messagesArray.removeAll()
                                self.tableView.reloadData()
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
                BlockUsersManager1.instanc.blockUnblockUser(session_Token: sessionToken, blockTo_userId: self.recipientID ?? "", block_Action: "block", completionBlock: { (success, sessionError, serverError, error) in
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
    
    private func changeChatColor(colorHexString:String){
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            ColorManager.instanc.changeChatColor(session_Token: sessionToken, receipentId: self.recipientID ?? "", colorHexString: colorHexString, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.color ?? "")")
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
    private func deleteMsssage(messageID:String, indexPath:Int){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            
            ChatManager.instance.deleteChatMessage(messageId: messageID , session_Token: sessionID, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.message ?? "")")
                            self.messagesArray.remove(at: indexPath)
                            var favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                            var message = favoriteAll[self.recipientID ?? ""] ?? []
                            
                            for (item,value) in message.enumerated(){
                                let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: value)
                                if favoriteMessage?.id == messageID{
                                    message.remove(at: item)
                                    break
                                }
                            }
                            favoriteAll[self.recipientID ?? ""] = message
                            UserDefaults.standard.setFavorite(value: favoriteAll , ForKey: Local.FAVORITE.favorite)
                            self.tableView.reloadData()
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
    private func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("View Profile", comment: "View Profile"),NSLocalizedString("Block User", comment: "Block User"),NSLocalizedString("Change Chat Theme", comment: "Change Chat Theme"),NSLocalizedString("Clear Chat", comment: "Clear Chat"), NSLocalizedString("Started Messages", comment: "Started Messages")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.navigateToUserProfile()
            }else if index == 1{
                self.blockUser()
            }else if index == 2{
                if let popoverController = MKColorPicker.popoverPresentationController{
                    popoverController.delegate = MKColorPicker
                    popoverController.permittedArrowDirections = .any
                    popoverController.sourceView = moreBtn
                    popoverController.sourceRect = moreBtn.bounds
                }
                
                self.present(MKColorPicker, animated: true, completion: nil)
            }else if index == 3{
                self.deleteChat()
            }else if index == 4{
                let vc = R.storyboard.favorite.favoriteVC()
                vc?.recipientID = self.recipientID ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            print("Index = \(index)")
        }
      
        
    }
    
    private func setupUI(){
        self.setupTapOnUsernameToViewProfile()
        self.toneStatus = UserDefaults.standard.getConversationTone(Key: Local.CONVERSATION_TONE.ConversationTone)
        self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        self.statusBarView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        self.sendBtn.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        self.microBtn.isHidden = true
        self.sendBtn.isHidden = false
        self.showAudioView.isHidden = true
        self.usernameLabel.text = userObject?.name ?? searchUserObject?.name ?? followingUserObject?.name ?? ""
        let url = URL.init(string:userObject?.avatar ?? searchUserObject?.avatar ?? followingUserObject?.avatar ?? "")
        self.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        self.usernameLabel.text = userObject?.name ?? searchUserObject?.name ?? followingUserObject?.name ?? ""
        
//        self.lastSeenLabel.text = "\(NSLocalizedString("last seen", comment: "last seen"))\(" ")\( setTimestamp(epochTime: (self.userObject?.lastseen  ?? "") ?? "") ?? setTimestamp(epochTime: (searchUserObject?.lastseen  ?? "") ?? "")   ?? setTimestamp(epochTime: (followingUserObject?.lastseen ?? "0") ?? "0")  ?? "0")"
        
        
        self.lastSeenLabel.text =  setTimestamp(epochTime: self.userObject?.lastseen  ?? searchUserObject?.lastseen  ??  followingUserObject?.lastseen ?? "0")
                                                
        self.sendBtn.cornerRadiusV = self.sendBtn.frame.height / 2
        self.microBtn.cornerRadiusV = self.microBtn.frame.height / 2
        self.showAudioPlayBtn.cornerRadiusV = self.showAudioPlayBtn.frame.height / 2
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.chatSenderTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier)
        tableView.register( R.nib.chatReceiverTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiver_TableCell.identifier)
        tableView.register( R.nib.chatSenderImageTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderImage_TableCell.identifier)
        tableView.register( R.nib.chatReceiverImageTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverImage_TableCell.identifier)
        tableView.register( R.nib.chatSenderContactTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderContact_TableCell.identifier)
        tableView.register( R.nib.chatReceiverContactTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverContact_TableCell.identifier)
        tableView.register( R.nib.chatSenderStickerTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderSticker_TableCel.identifier)
        tableView.register( R.nib.chatReceiverStrickerTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverStricker_TableCell.identifier)
        
        tableView.register( R.nib.chatSenderAudioTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderAudio_TableCell.identifier)
        
        tableView.register( R.nib.chatReceiverAudioTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverAudio_TableCell.identifier)
        
        tableView.register( R.nib.chatSenderDocumentTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatSenderDocument_TableCell.identifier)
        tableView.register( R.nib.chatReceiverDocumentTableCell(), forCellReuseIdentifier: R.reuseIdentifier.chatReceiverDocument_TableCell.identifier)
        tableView.register( R.nib.replyChatSenderTableItem(), forCellReuseIdentifier: R.reuseIdentifier.replyChatSenderTableItem.identifier)
        tableView.register( R.nib.replyReceiverTableItem(), forCellReuseIdentifier: R.reuseIdentifier.replyReceiverTableItem.identifier)
        
        self.adjustHeight()
        //        self.textViewPlaceHolder()
        
    }
    private func adjustHeight(){
        let size = self.messageTxtView.sizeThatFits(CGSize(width: self.messageTxtView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        textViewHeightContraint.constant = size.height
        self.viewDidLayoutSubviews()
        self.messageTxtView.setContentOffset(CGPoint.zero, animated: false)
    }
    private func textViewPlaceHolder(){
        messageTxtView.delegate = self
        messageTxtView.text = NSLocalizedString("Your message here...", comment: "Your message here...")
        messageTxtView.textColor = UIColor.lightGray
    }
    private func openVideoGallery(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func animateRepltyView() {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.layoutSubviews, animations: {
            self.view.layoutSubviews()
        }, completion: nil)
    }
    
    @IBAction func cancelReplyPressed(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.cancelPressed.isHidden = true
        self.replyUsernameLabel.isHidden = true
        self.replyTextLabel.isHidden = true
        self.replyInView.isHidden = true
        self.sideView.isHidden = true
        self.replyMessageID = "0"
        self.isReplyStatus = false
        self.animateRepltyView()
    }
    func swipeToReply(index: IndexPath){
        self.heightConstraint.constant = 100
        self.cancelPressed.isHidden = false
        self.replyUsernameLabel.isHidden = false
        self.replyTextLabel.isHidden = false
        self.replyInView.isHidden = false
        self.sideView.isHidden = false
        self.messageTxtView.becomeFirstResponder()
        self.animateRepltyView()
    }
}


extension  ChatScreenVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let image:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            log.verbose("image = \(image ?? nil)")
            let imageData = image?.jpegData(compressionQuality: 0.1)
            log.verbose("MimeType = \(imageData?.mimeType)")
            sendSelectedData(audioData: nil, imageData: imageData, videoData: nil, imageMimeType: imageData?.mimeType, VideoMimeType: nil, audioMimeType: nil, Type: "image", fileData: nil, fileExtension: nil, FileMimeType: nil)
            
        }
        
        if let fileURL:URL? = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            if let url = fileURL {
                let videoData = try? Data(contentsOf: url)
                
                log.verbose("MimeType = \(videoData?.mimeType)")
                print(videoData?.mimeType)
                sendSelectedData(audioData: nil, imageData: nil, videoData: videoData, imageMimeType: nil, VideoMimeType: videoData?.mimeType, audioMimeType: nil, Type: "video", fileData: nil, fileExtension: nil, FileMimeType: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func sendSelectedData(audioData:Data?,imageData:Data?,videoData:Data?, imageMimeType:String?,VideoMimeType:String?,audioMimeType:String?,Type:String?,fileData:Data?,fileExtension:String?,FileMimeType:String?){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let sessionId = AppInstance.instance.sessionId ?? ""
        let dataType = Type ?? ""
        
        if dataType == "image"{
            Async.background({
                ChatManager.instance.sendChatData(message_hash_id: messageHashId, receipent_id: self.recipientID ?? "", session_Token: sessionId, type: dataType, audio_data: nil, image_data: imageData, video_data: nil, imageMimeType: imageMimeType, videoMimeType: nil, audioMimeType: nil, text: "", file_data: nil, file_Extension: nil, fileMimeType: nil) { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.messageData ?? [])")
                                let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
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
                }
            })
        }
        //To send an audio message
        else if dataType == "audio"{
            Async.background({
                ChatManager.instance.sendChatData(message_hash_id: messageHashId, receipent_id: self.recipientID ?? "", session_Token: sessionId, type: dataType, audio_data: audioData, image_data: nil, video_data: nil, imageMimeType: nil, videoMimeType: nil,audioMimeType: audioMimeType, text: "", file_data: nil, file_Extension: "wav", fileMimeType: nil) { (success, sessionError, serverError, error) in
                    
                    if success != nil {
                        log.verbose("audio message send successfully")
                    }else {
                        log.verbose("faild to send an audio message")
                    }
                                        if success != nil{
                                            Async.main({
                                                self.dismissProgressDialog {
                                                    log.debug("userList = \(success?.messageData ?? [])")
                                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
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
                }
            })
        }
        
        else if dataType == "video"{
            
            Async.background({
                ChatManager.instance.sendChatData(message_hash_id: messageHashId, receipent_id: self.recipientID ?? "", session_Token: sessionId, type: dataType, audio_data: nil, image_data: nil, video_data: videoData, imageMimeType: nil, videoMimeType: VideoMimeType, audioMimeType: nil, text: "", file_data: nil, file_Extension: nil, fileMimeType: nil) { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.messageData ?? [])")
                                let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                
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
                }
            })
            
        }else{
            Async.background({
                ChatManager.instance.sendChatData(message_hash_id: messageHashId, receipent_id: self.recipientID ?? "", session_Token: sessionId, type: dataType, audio_data: nil, image_data: nil, video_data: nil, imageMimeType: nil, videoMimeType: nil,audioMimeType: nil, text: "", file_data: fileData, file_Extension: fileExtension, fileMimeType: FileMimeType) { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.messageData ?? [])")
                                let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                
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
                }
            })
        }
        
    }
}
extension ChatScreenVC:SelectContactDetailDelegate {
    func selectContact(key:String,value:String) {
        var extendedParam = ["key":key,"value":value] as? [String:String]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject:extendedParam,options: []){
            let theJSONText = String(data: theJSONData,encoding: String.Encoding.utf8)
            log.verbose("JSON string = \(theJSONText)")
            self.sendContact(jsonPayload: theJSONText)
        }
    }
    
    private func sendContact(jsonPayload:String?){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let jsonPayloadString = jsonPayload ??  ""
        let recipientId = self.recipientID ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            ChatManager.instance.sendContact(message_hash_id: messageHashId, receipent_id: recipientId, jsonPayload: jsonPayload ?? "",session_Token: sessionID, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.messageData ?? [])")
                            let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                            
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

extension ChatScreenVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL?) {
        let cico = url as? URL
        print(cico)
        print(url)
        print(url!.lastPathComponent.split(separator: ".").last)
        print(url!.pathExtension)
        if let urlfile = url {
            let fileData = try? Data(contentsOf: urlfile)
            log.verbose("File Data = \(fileData)")
            log.verbose("MimeType = \(fileData?.mimeType)")
            
            let fileExtension = String(url!.lastPathComponent.split(separator: ".").last!)
            sendSelectedData(audioData: nil,imageData: nil, videoData: nil, imageMimeType: nil, VideoMimeType: nil, audioMimeType: nil, Type: "file", fileData: fileData, fileExtension: fileExtension, FileMimeType: fileData?.mimeType)
        }
    }
}

extension ChatScreenVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustHeight()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if ControlSettings.socketChat{
            let data = [
                "recipient_id":self.recipientID ?? "",
                "user_id":AppInstance.instance.sessionId ?? ""
            ]
            SocketIOManager.sharedInstance.sendTyping(message: SocketEvents.SocketEventconstantsUtils.EVENT_TYPING, recipentID: self.recipientID ?? "", userID: AppInstance.instance.sessionId ?? "") {
                log.verbose("Emmited")
            }
        }else{
            log.verbose("Nothing")
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            self.messageTxtView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Your message here...", comment: "Your message here...")
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension ChatScreenVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let reply = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
              completionHandler(true)
          }
          reply.image = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
              UIImage(named: "reply")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
          }
        reply.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [reply])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        
          let cellClass = self.tableView.cellForRow(at: indexPath)
          if let chatCell = cellClass as? ChatSender_TableCell {
              self.replyUsernameLabel.text = "You"
              self.replyTextLabel.text = chatCell.messageTxtView.text
          
            self.swipeToReply(index: indexPath)
            self.isReplyStatus = true
            self.replyMessageID = self.messagesArray[indexPath.row].id ?? ""
            return swipeActionConfig
          }else if let revchatCell = cellClass as? ChatReceiver_TableCell {
              self.replyUsernameLabel.text = self.usernameLabel.text
              self.replyTextLabel.text = revchatCell.messageTxtView.text
//            reply.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
//            let swipeActionConfig = UISwipeActionsConfiguration(actions: [reply])
//            swipeActionConfig.performsFirstActionWithFullSwipe = false
            self.swipeToReply(index: indexPath)
            self.isReplyStatus = true
            self.replyMessageID = self.messagesArray[indexPath.row].id ?? ""
            return swipeActionConfig
          }else if let cell = cellClass as? ReplyChatSenderTableItem{
            self.replyUsernameLabel.text = "You"
            self.replyTextLabel.text = cell.messageTextLabel.text ?? ""
//            reply.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
//            let swipeActionConfig = UISwipeActionsConfiguration(actions: [reply])
//            swipeActionConfig.performsFirstActionWithFullSwipe = false
            self.swipeToReply(index: indexPath)
            self.isReplyStatus = true
            self.replyMessageID = self.messagesArray[indexPath.row].id ?? ""
            return swipeActionConfig
        }else if let revchatCell = cellClass as? replyReceiverTableItem {
            self.replyUsernameLabel.text = self.usernameLabel.text
            self.replyTextLabel.text = revchatCell.messageTextLabel.text
//            reply.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
//            let swipeActionConfig = UISwipeActionsConfiguration(actions: [reply])
//            swipeActionConfig.performsFirstActionWithFullSwipe = false
            self.swipeToReply(index: indexPath)
            self.isReplyStatus = true
            self.replyMessageID = self.messagesArray[indexPath.row].id ?? ""
            return swipeActionConfig
        }
       
        
        
//        else if let _ = cellClass as? ChatSenderImage_TableCell{
//            self.replyUsernameLabel.text = "You"
//            self.replyTextLabel.text = "Image"
//        }else if let _ = cellClass as? ChatReceiverImage_TableCell{
//            self.replyUsernameLabel.text = self.usernameLabel.text
//            self.replyTextLabel.text = "Image"
//        }else if let _ = cellClass as? ChatSenderImage_TableCell{
//            self.replyUsernameLabel.text = self.usernameLabel.text
//            self.replyTextLabel.text = "Image"
//        }else if let _ = cellClass as? ChatReceiverImage_TableCell{
//            self.replyUsernameLabel.text = self.usernameLabel.text
//            self.replyTextLabel.text = "Image"
//        }
        
  ////        else if let _ = cellClass as? ChatSenderContact_TableCell{
  ////            self.replyusernameLabel.text = self.usernameLabel.text
  ////            self.replyTextLabel.text = "Image"
  //        }
return nil
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.messagesArray.count == 0{
            return UITableViewCell()
        }
        let object = self.messagesArray[indexPath.row]
        if object.reply?.text != nil{
            if object.type == "right_text"{
                let lat = Double(object.lat ?? "0.0") ?? 0.0
                let long = Double(object.lng ?? "0.0") ?? 0.0
                if lat > 0.0 || long > 0.0 {
                    //for maps for sender
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.replyChatSenderTableItem.identifier) as? ReplyChatSenderTableItem
                    cell?.selectionStyle = .none
                    
                    let url = URL.init(string:"https://i.imgflip.com/40sgnq.png")
//                        cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
//                        cell?.stickerImage.contentMode = .scaleAspectFill
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
//                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
//                        cell?.timeLabel.text = time
                        cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                            cell?.starBtn.isHidden = false
                    }else{
                            cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
                else {
                    //show text on right
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.replyChatSenderTableItem.identifier) as? ReplyChatSenderTableItem
                    cell?.selectionStyle = .none
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.tabStops = [
                        NSTextTab(textAlignment: .right, location: 0, options: [:]),
                    ]
                    var str = "\(self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "") ?? object.text ?? "")"
                    if object.seen != "0"{
//                        str += "\n\(NSLocalizedString("seen", comment: "seen"))"
                    }
                    if object.reply?.fromID == AppInstance.instance.userId ?? ""{
                        cell?.usernameLabel.text = "You"
                    }else{
                        cell?.usernameLabel.text = self.usernameLabel.text ?? ""
                    }
                    
                    cell?.userTextLabel.text =  "\(self.decryptionAESModeECB(messageData: object.reply?.text?.htmlAttributedString ?? "", key: object.reply?.time ?? "") ?? object.reply?.text ?? "")"
                    let attributed = NSAttributedString(
                        string: str,
                        attributes: [NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                    )
                    
                        cell?.messageTextLabel.attributedText = attributed
                        cell?.messageTextLabel.isEditable = false
                        cell?.messageTextLabel.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    cell?.inSideView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll = UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                            cell?.starBtn.isHidden = false
                        
                    }else{
                            cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
            }else if object.type == "left_text"{
                let lat = Double(object.lat ?? "0.0") ?? 0.0
                let long = Double(object.lng ?? "0.0") ?? 0.0
                if lat > 0.0 || long > 0.0 {
                    //for maps for sender
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.replyReceiverTableItem.identifier) as? replyReceiverTableItem
                    cell?.selectionStyle = .none
                    
                    let url = URL.init(string:"https://i.imgflip.com/40sgnq.png")
//                        cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
//                        cell?.stickerImage.contentMode = .scaleAspectFill
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
//                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
//                        cell?.timeLabel.text = time
                        cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                            cell?.starBtn.isHidden = false
                    }else{
                            cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
                else {
                    //show text on right
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.replyReceiverTableItem.identifier) as? replyReceiverTableItem
                    cell?.selectionStyle = .none
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.tabStops = [
                        NSTextTab(textAlignment: .right, location: 0, options: [:]),
                    ]
                    var str = "\(self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "") ?? object.text ?? "")"
                    if object.seen != "0"{
//                        str += "\n\(NSLocalizedString("seen", comment: "seen"))"
                    }
                    if object.reply?.fromID == AppInstance.instance.userId ?? ""{
                        cell?.usernameLabel.text = "You"
                    }else{
                        cell?.usernameLabel.text = self.usernameLabel.text ?? ""
                    }
                    
                    cell?.userTextLabel.text =  "\(self.decryptionAESModeECB(messageData: object.reply?.text ?? "", key: object.reply?.time ?? "") ?? object.reply?.text ?? "")"
                    let attributed = NSAttributedString(
                        string: str,
                        attributes: [NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                    )
                    
                        cell?.messageTextLabel.attributedText = attributed
                        cell?.messageTextLabel.isEditable = false
//                        cell?.messageTextLabel.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
//                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
//                    cell?.inSideView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll = UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                            cell?.starBtn.isHidden = false
                        
                    }else{
                            cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
            }else{
                
            }
        }else{
            if object.media == ""{
                if object.type == "right_text"{
                    let lat = Double(object.lat ?? "0.0") ?? 0.0
                    let long = Double(object.lng ?? "0.0") ?? 0.0
                    if lat > 0.0 || long > 0.0 {
                        //for maps for sender
                        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderSticker_TableCel.identifier) as? ChatSenderSticker_TableCell
                        cell?.selectionStyle = .none
                        
                        let url = URL.init(string:"https://i.imgflip.com/40sgnq.png")
                        cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                        cell?.stickerImage.contentMode = .scaleAspectFill
                        var time = setLocalDate(timeStamp: object.time)
                        if object.seen != "0" {
    //                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                        }
                        cell?.timeLabel.text = time
                        cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                        let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                        let message = favoriteAll[self.recipientID ?? ""] ?? []
                        var status:Bool? = false
                        for item in message{
                            let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                            if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                                status = true
                                break
                            }else{
                                status = false
                            }
                        }
                        if status ?? false{
                            cell?.starBtn.isHidden = false
                        }else{
                            cell?.starBtn.isHidden = true
                        }
                        return cell!
                    }
                    else {
                        //show text on right
                        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier) as? ChatSender_TableCell
                        cell?.selectionStyle = .none
                        let paragraph = NSMutableParagraphStyle()
                        paragraph.tabStops = [
                            NSTextTab(textAlignment: .right, location: 0, options: [:]),
                        ]
                        var str = "\(self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "") ?? object.text ?? "")"
                        if object.seen != "0"{
    //                        str += "\n\(NSLocalizedString("seen", comment: "seen"))"
                        }
                        
                        let attributed = NSAttributedString(
                            string: str,
                            attributes: [NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                        )
                        cell?.messageTxtView.attributedText = attributed
                        cell?.messageTxtView.isEditable = false
                        cell?.messageTxtView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                        let favoriteAll = UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                        let message = favoriteAll[self.recipientID ?? ""] ?? []
                        var status:Bool? = false
                        for item in message{
                            let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                            if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                                status = true
                                break
                            }else{
                                status = false
                            }
                        }
                        if status ?? false{
                            cell?.starBtn.isHidden = false
                            
                        }else{
                            cell?.starBtn.isHidden = true
                        }
                        return cell!
                    }
                }else if object.type == "left_text"{
                    let lat = Double(object.lat ?? "0")!
                    let long = Double(object.lng ?? "0")!
                    if lat > 0.0 || long > 0.0 {
                        //for map on left
                        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverStricker_TableCell.identifier) as? ChatReceiverStricker_TableCell
                        cell?.selectionStyle = .none
                        let url = URL.init(string:"https://i.imgflip.com/40sgnq.png")
                        cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                        let time = setLocalDate(timeStamp: object.time)
                        cell?.timeLabel.text = time
                        cell?.timeLabel.text = object.timeText ?? ""
                        let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                        let message = favoriteAll[self.recipientID ?? ""] ?? []
                        var status:Bool? = false
                        for item in message{
                            let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                            if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                                status = true
                                break
                            }else{
                                status = false
                            }
                        }
                        if status ?? false{
                            cell?.starBtn.isHidden = false
                            
                        }else{
                            cell?.starBtn.isHidden = true
                        }
                        return cell!
                    }
                    else {
                        //show text on right
                        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiver_TableCell.identifier) as? ChatReceiver_TableCell
                        cell?.selectionStyle = .none
                        cell?.messageTxtView.text = (self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "")) ?? object.text ?? "" + "\n\n\(setLocalDate(timeStamp: object.time))" ?? ""
                        cell?.messageTxtView.isEditable = false
                        let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                        let message = favoriteAll[self.recipientID ?? ""] ?? []
                        var status:Bool? = false
                        for item in message{
                            let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                            if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                                status = true
                                break
                            }else{
                                status = false
                            }
                        }
                        if status ?? false{
                            cell?.starBtn.isHidden = false
                            
                        }else{
                            cell?.starBtn.isHidden = true
                        }
                        return cell!
                    }
                }else if object.type == "right_contact"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderContact_TableCell.identifier) as? ChatSenderContact_TableCell
                    cell?.selectionStyle = .none
                    let data = object.text?.htmlAttributedString!.data(using: String.Encoding.utf8)
                    let result = try? JSONDecoder().decode(ContactModel.self, from: data ?? Data())
                    log.verbose("Result Model = \(result)")
                    let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                    log.verbose("dictionary = \(dic)")
                    cell?.nameLabel.text = "\(dic?["key"] ?? "")"
                    cell?.contactLabel.text  =  "\(dic?["value"] ?? "")"
                    cell?.timeLabel.text = object.timeText ?? ""
                    cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    log.verbose("object.text?.htmlAttributedString? = \(object.text?.htmlAttributedString)")
                    let newString = object.text?.htmlAttributedString!.replacingOccurrences(of: "\\\\", with: "")
                    log.verbose("newString= \(newString)")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
                else if (object.type == "left_product"){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductTableCell
                    cell.selectionStyle = .none
                    cell.productName.text = object.product?.name ?? ""
                    cell.price.text = "\("$ ")\(object.product?.price ?? "")"
                    cell.dateLabel.text = object.timeText ?? ""
                    cell.productCategory.text = "Autos & Vechicles"
                    let image = object.product?.images?[0].image
                    let url = URL(string: image ?? "")
                    cell.productImage.sd_setImage(with: url, completed: nil)
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell.starBtn.isHidden = false
                        
                    }else{
                        cell.starBtn.isHidden = true
                    }
                    return cell
                }
                else if object.type == "right_gif"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderSticker_TableCel.identifier) as? ChatSenderSticker_TableCell
                    cell?.selectionStyle = .none
                    let url = URL.init(string:object.stickers ?? "")
                    cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
                    cell?.timeLabel.text = time
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
                else if object.type == "left_gif"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverStricker_TableCell.identifier) as? ChatReceiverStricker_TableCell
                    cell?.selectionStyle = .none
                    let url = URL.init(string:object.media ?? "")
                    cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                    var time = setLocalDate(timeStamp: object.time)
                    cell?.timeLabel.text = time
                    cell?.timeLabel.text = object.timeText ?? ""
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                        
                        
                    }
                    
                    return cell!
                }
                
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverContact_TableCell.identifier) as? ChatReceiverContact_TableCell
                    cell?.selectionStyle = .none
                    log.verbose("object.text?.htmlAttributedString? = \(object.text?.htmlAttributedString)")
                    let newString = object.text?.htmlAttributedString!.replacingOccurrences(of: "\\\\", with: "")
                    log.verbose("newString= \(newString)")
                    let data = object.text?.htmlAttributedString?.data(using: String.Encoding.utf8)
                    //                let result = try? JSONDecoder().decode(ContactModel.self, from: data!)
                    let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                    log.verbose("dictionary = \(dic)")
                    cell?.nameLabel.text = "\(dic?["key"] ?? "")"
                    cell?.contactLabel.text  =  "\(dic?["value"] ?? "")"
                    
                    cell?.timeLabel.text = object.timeText ?? ""
                    cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
            }else{
                if object.type == "right_image"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderImage_TableCell.identifier) as? ChatSenderImage_TableCell
                    cell?.selectionStyle = .none
                    cell?.fileImage.isHidden = false
                    cell?.videoView.isHidden = true
                    cell?.playBtn.isHidden = true
                    let url = URL.init(string:object.media ?? "")
                    cell?.fileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
                    cell?.timeLabel.text = time
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }else if object.type == "left_image" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverImage_TableCell.identifier) as? ChatReceiverImage_TableCell
                    cell?.selectionStyle = .none
                    cell?.fileImage.isHidden = false
                    cell?.videoView.isHidden = true
                    cell?.playBtn.isHidden = true
                    let url = URL.init(string:object.media ?? "")
                    cell?.fileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
                    cell?.timeLabel.text = setLocalDate(timeStamp: object.time)
                    cell?.backGroundView?.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }else  if object.type == "right_video"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderImage_TableCell.identifier) as? ChatSenderImage_TableCell
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
                    cell?.selectionStyle = .none
                    cell?.fileImage.isHidden = true
                    cell?.videoView.isHidden = false
                    cell?.playBtn.isHidden = false
                    cell?.delegate = self
                    cell?.index  = indexPath.row
                    let videoURL = URL(string: object.media ?? "")
                    player = AVPlayer(url: videoURL! as URL)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    self.addChild(playerController)
                    playerController.view.frame = self.view.frame
                    cell?.videoView.addSubview(playerController.view)
                    player.pause()
                    cell?.timeLabel.text = time
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                        
                        
                    }
                    return cell!
                    
                    
                }else if object.type == "left_video"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverImage_TableCell.identifier) as? ChatReceiverImage_TableCell
                    cell?.selectionStyle = .none
                    cell?.fileImage.isHidden = true
                    cell?.videoView.isHidden = false
                    cell?.playBtn.isHidden = false
                    cell?.delegate = self
                    cell?.index  = indexPath.row
                    let videoURL = URL(string: object.media ?? "")
                    player = AVPlayer(url: videoURL! as URL)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    self.addChild(playerController)
                    playerController.view.frame = self.view.frame
                    cell?.videoView.addSubview(playerController.view)
                    
                    //                if self.count == 0 {
                    //                    self.count = self.count + 1
                    //                    Async.background({
                    //                        let asset = AVAsset(url: videoURL!)
                    //                        let imageGenerator = AVAssetImageGenerator(asset: asset)
                    //                        let screenshotTime = CMTime(seconds: 1, preferredTimescale: 1)
                    //                        imageGenerator.appliesPreferredTrackTransform = true
                    //                        let imageRef = try? imageGenerator.copyCGImage(at: screenshotTime, actualTime: nil)
                    //                        let thumbnail = UIImage(cgImage: imageRef!)
                    //                        Async.main({
                    //                            let thumbImage = UIImageView()
                    //                            thumbImage.image = thumbnail
                    //                            cell?.videoView.addSubview(thumbImage)
                    //                            thumbImage.frame = cell!.frame
                    //                        })
                    //                    })
                    //                }
                    
                    
                    
                    
                    
                    
                    
                    player.pause()
                    cell?.timeLabel.text = setLocalDate(timeStamp: object.time)
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    return cell!
                }
                //                else if object.type == "right_gif"{
                //                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderSticker_TableCel.identifier) as? ChatSenderSticker_TableCell
                //                cell?.selectionStyle = .none
                //                let url = URL.init(string:object.stickers ?? "")
                //                cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                //                var time = setLocalDate(timeStamp: object.time)
                //                if object.seen != "0" {
                //                    time += "  seen"
                //                }
                //                cell?.timeLabel.text = time
                //                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                //                let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                //                let message = favoriteAll[self.recipientID ?? ""] ?? []
                //                var status:Bool? = false
                //                for item in message{
                //                    let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                //                    if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                //                        status = true
                //                        break
                //                    }else{
                //                        status = false
                //                    }
                //                }
                //                if status ?? false{
                //                    cell?.starBtn.isHidden = false
                //
                //                }else{
                //                    cell?.starBtn.isHidden = true
                //                }
                //                return cell!
                //
                //            }else if object.type == "left_sticker"{
                //                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverStricker_TableCell.identifier) as? ChatReceiverStricker_TableCell
                //                cell?.selectionStyle = .none
                //                let url = URL.init(string:object.media ?? "")
                //                cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                //                var time = setLocalDate(timeStamp: object.time)
                //                cell?.timeLabel.text = time
                //                cell?.timeLabel.text = object.timeText ?? ""
                //                let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                //                let message = favoriteAll[self.recipientID ?? ""] ?? []
                //                var status:Bool? = false
                //                for item in message{
                //                    let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                //                    if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                //                        status = true
                //                        break
                //                    }else{
                //                        status = false
                //                    }
                //                }
                //                if status ?? false{
                //                    cell?.starBtn.isHidden = false
                //
                //                }else{
                //                    cell?.starBtn.isHidden = true
                //
                //
                //                }
                //
                //                return cell!
                //            }
                else if  object.type == "right_audio"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderAudio_TableCell.identifier) as? ChatSenderAudio_TableCell
                    cell?.selectionStyle = .none
                    cell?.delegate = self
                    cell?.index = indexPath.row
                    cell?.url = object.media ?? ""
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
                    cell?.timeLabel.text = time
                    cell?.durationLabel.text = NSLocalizedString("Loading...", comment: "Loading...")
                    Async.background({
                        let audioURL = URL(string: object.media ?? "")
                        self.player = AVPlayer(url: audioURL! as URL)
                        cell?.timeLabel.text = self.setLocalDate(timeStamp: object.time)
                        let currentItem = self.player.currentItem
                        let duration = currentItem!.asset.duration
                        Async.main({
                            cell?.durationLabel.text = duration.durationText
                        })
                    })
                    
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                        
                        
                    }
                    
                    return cell!
                }else if object.type == "left_audio"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverAudio_TableCell.identifier) as? ChatReceiverAudio_TableCell
                    cell?.selectionStyle = .none
                    cell?.delegate = self
                    cell?.index = indexPath.row
                    cell?.url = object.media ?? ""
                    cell?.durationLabel.text = NSLocalizedString("Loading...", comment: "Loading...")
                    
                    if isFistTry == true {
                        
                        Async.background({
                            let audioURL = URL(string: object.media ?? "")
                            self.player = AVPlayer(url: audioURL! as URL)
                            let currentItem = self.player.currentItem
                            let duration = currentItem!.asset.duration
                            self.isFistTry = false
                            Async.main({
                                self.audioDuration = duration.durationText
                                cell?.durationLabel.text = duration.durationText
                            })
                        })
                    }else {
                        cell?.durationLabel.text = audioDuration
                        
                    }
                    cell?.timeLabel.text = self.setLocalDate(timeStamp: object.time)
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                    }
                    
                    return cell!
                    
                }else if object.type == "right_file"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderDocument_TableCell.identifier) as? ChatSenderDocument_TableCell
                    cell?.selectionStyle = .none
                    cell?.fileNameLabel.text = object.mediaFileName ?? ""
                    var time = setLocalDate(timeStamp: object.time)
                    if object.seen != "0" {
                        time += "  \(NSLocalizedString("seen", comment: "seen"))"
                    }
                    cell?.timeLabel.text = time
                    cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                        
                        
                    }
                    return cell!
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverDocument_TableCell.identifier) as? ChatReceiverDocument_TableCell
                    cell?.selectionStyle = .none
                    cell?.nameLabel.text = object.mediaFileName ?? ""
                    var time = setLocalDate(timeStamp: object.time)
                    cell?.timeLabel.text = time
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                            status = true
                            break
                        }else{
                            status = false
                        }
                    }
                    if status ?? false{
                        cell?.starBtn.isHidden = false
                        
                    }else{
                        cell?.starBtn.isHidden = true
                        
                        
                    }
                    return cell!
                }
                
            }
        }
       
        
      return UITableViewCell()
    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = self.messagesArray[indexPath.row]
        if index.lat != "0" {
            //            URL(string: "https://www.google.com/maps/search/?api=1&query=\(index.lat),\(index.long)")
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(index.lat ?? "0.0"),\(index.lng ?? "0.0")&zoom=14&views=traffic&q=\(index.lat ?? "0.0"),\(index.lng ?? "0.0")")!, options: [:], completionHandler: nil)
            } else {
                self.view.makeToast(NSLocalizedString("google maps not found", comment: "google maps not found"))
            }
        }
        else {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            let copy = UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default) { (action) in
                log.verbose("Copy")
                UIPasteboard.general.string = self.messagesArray[indexPath.row].text ?? ""
            }
            let messageInfo = UIAlertAction(title: NSLocalizedString("Message Info", comment: "Message Info"), style: .default) { (action) in
                log.verbose("message Info")
                let vc = R.storyboard.favorite.chatInfoVC()
                vc?.object = self.messagesArray[indexPath.row]
                vc?.chatColor = self.chatColorHex ?? ""
                vc?.recipientID = self.recipientID ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            let deleteMessage = UIAlertAction(title: NSLocalizedString("Delete Message", comment: "Delete Message"), style: .default) { (action) in
                log.verbose("Delete Message")
//                if .self.messagesArray[indexPath.row].toID  == AppInstance.instance.userId  ?? ""{
//                    log.verbose("Message not deleted")
//                }else{
//                    self.deleteMsssage(messageID: self.messagesArray[indexPath.row].id ?? "", indexPath: indexPath.row)
//                }
                self.deleteMsssage(messageID: self.messagesArray[indexPath.row].id ?? "", indexPath: indexPath.row)

                
                
            }
            let forwardMessage = UIAlertAction(title: NSLocalizedString("Forward", comment: "Forward"), style: .default) { (action) in
                log.verbose("Farword Message")
                log.verbose("message Info")
                let vc = R.storyboard.favorite.getFriendVC()
                vc?.messageString = self.messagesArray[indexPath.row].text ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            
            let view = UIAlertAction(title: NSLocalizedString("View", comment: "View"), style: .default) { (action) in
                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let url = URL(string: index.media ?? "")
                let extenion =  url?.pathExtension
                if (extenion == "jpg") || (extenion == "png") || (extenion == "JPG") || (extenion == "PNG"){
                    let vc = storyboard.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageController
                    vc.imageURL = index.media ?? ""
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    let player = AVPlayer(url: URL(string: index.media ?? "")!)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                }
            }
            let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
            let message = favoriteAll[self.recipientID ?? ""] ?? []
            var  favoriteMessage:UIAlertAction?
            
            var status:Bool? = false
            for item in message{
                let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                if self.messagesArray[indexPath.row].id ?? "" == favoriteMessage?.id ?? ""{
                    status = true
                    break
                }else{
                    status = false
                }
            }
            if status ?? false{
                favoriteMessage = UIAlertAction(title: NSLocalizedString("Un favorite", comment: "Un favorite"), style: .default) { (action) in
                    log.verbose("favorite message = \(indexPath.row)")
                    self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row])
                }
                
            }else{
                favoriteMessage = UIAlertAction(title: NSLocalizedString("Favorite", comment: "Favorite"), style: .default) { (action) in
                    log.verbose("favorite message = \(indexPath.row)")
                    self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row])
                }
                
            }
            let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "CANCEL"), style: .destructive, handler: nil)
//            if (index.product != nil){
//                //            alert.addAction(forwardMessage)
//                alert.addAction(favoriteMessage!)
//                alert.addAction(cancel)
//                self.present(alert, animated: true, completion: nil)
//
//            }
//            else{
//                if (index.media != ""){
//                    alert.addAction(view)
//                }
            
            if self.messagesArray[indexPath.row].toID  == AppInstance.instance.userId  ?? ""{
                log.verbose("Noting to add ")
            }else{
                alert.addAction(deleteMessage)
            }
                alert.addAction(copy)
                alert.addAction(messageInfo)
                alert.addAction(forwardMessage)
                alert.addAction(favoriteMessage!)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
//            }
            
        }
        
    }
    private func setFavorite(receipentID:String,ID:String,object:UserChatModel.Message){
        var data = Data()
        
        let objectToEncode = object
        data = try! PropertyListEncoder().encode(objectToEncode)
        
        log.verbose("Check = \(UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite))")
        var dataDic = UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
        var getfavoriteMessages  =  dataDic[receipentID] ?? []
        if  getfavoriteMessages.contains(data){
            for (item,value) in getfavoriteMessages.enumerated(){
                if data == value{
                    self.index = item
                    break
                }
            }
            getfavoriteMessages.remove(at:self.index ?? 0)
            
            dataDic[receipentID] = getfavoriteMessages
            UserDefaults.standard.setFavorite(value: dataDic , ForKey: Local.FAVORITE.favorite)
            self.view.makeToast(NSLocalizedString("remove from   favorite", comment: "remove from   favorite"))
            self.tableView.reloadData()
            
        }else{
            getfavoriteMessages.append(data)
            dataDic[receipentID] = getfavoriteMessages
            UserDefaults.standard.setFavorite(value: dataDic , ForKey: Local.FAVORITE.favorite)
            //                     self.buttonStar.setImage(UIImage(named: "star_yellow"), for: .normal)
            self.view.makeToast(NSLocalizedString("Added to favorite", comment: "Added to favorite"))
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   UITableView.automaticDimension
        
        //        240.0
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension ChatScreenVC:PlayVideoDelegate{
    func playVideo(index: Int, status: Bool) {
        if status{
            //            self.player.play()
            log.verbose(" self.player.play()")
        }else{
            log.verbose("self.player.pause()")
            //            self.player.pause()
        }
    }
    
    
}
extension ChatScreenVC:PlayAudioDelegate{
    func playAudio(index: Int, status: Bool, url: URL, button: UIButton) {
        if status{
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!//since it sys
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            log.verbose("destinationUrl is = \(destinationUrl)")
            
            self.playerItem = AVPlayerItem(url: destinationUrl)
            self.player = AVPlayer(playerItem: self.playerItem)
            let playerLayer=AVPlayerLayer(player: self.player)
            self.player.play()
            button.setImage(R.image.ic_pauseBtn(), for: .normal)
        }else{
            self.player.pause()
            button.setImage(R.image.ic_playBtn(), for: .normal)
        }
        
        
    }
}


extension ChatScreenVC:CallReceiveDelegate{
    func receiveCall(callId: Int, RoomId: String, callingType: String, username: String, profileImage: String,accessToken:String?) {
        //Check weather the to use agora or twilio
        if ControlSettings.agoraCall == true &&  ControlSettings.twilloCall == false{
            //Agora video call
            if callingType == "video"{
                let vc  = R.storyboard.call.videoCallVC()
                vc?.callId = callId
                vc?.roomID = RoomId
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            //Agora Audio calll
            else {
                let vc  = R.storyboard.call.agoraCallVC()
                vc?.callId = callId
                vc?.roomID = RoomId
                vc?.usernameString = username
                vc?.profileImageUrlString = profileImage
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        //Twilio Call
        else {
            if callingType == "video"{
                //Twilio video call
                if self.navigationController?.viewControllers.last is TwilloVideoCallVC {
                    log.verbose("Video call controller is already presented")
                }else {
                    let vc = R.storyboard.call.twilloVideoCallVC()
                    vc?.accessToken = accessToken ?? ""
                    vc?.roomId = RoomId ?? ""
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
            //Twilio Audio call
            else{
                if self.navigationController?.viewControllers.last is TwilloAudioCallVC {
                    log.verbose("Audio call controller is already presented")
                }else {
                    let vc = R.storyboard.call.twilloAudioCallVC()
                    vc?.accessToken = accessToken ?? ""
                    vc?.roomId = RoomId ?? ""
                    vc?.profileImageUrlString = profileImage
                    vc?.usernameString = username
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
}
extension  ChatScreenVC:didSelectGIFDelegate{
    
    func didSelectGIF(GIFUrl: String, id: String) {
        self.sendGIF(url: GIFUrl)
    }
    
    private func sendGIF(url:String){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTxtView.text ?? ""
        let recipientId = self.recipientID ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            ChatManager.instance.sendGIF(message_hash_id: messageHashId, receipent_id: recipientId, URl:url , session_Token: sessionID) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if self.messagesArray.count == 0{
                                log.verbose("Will not scroll more")
                                self.view.resignFirstResponder()
                            }else{
                                if self.toneStatus!{
                                    self.playSendMessageSound()
                                }else{
                                    log.verbose("To play sound please enable conversation tone from settings..")
                                }
                                self.messageTxtView.text = ""
                                self.view.resignFirstResponder()
                                log.debug("userList = \(success?.messageData ?? [])")
                                let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
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
            }
        })
    }
}

extension ChatScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tempMsg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TempMsgCollectionViewCell
        cell.layer.cornerRadius = 18
        cell.borderColorV = .darkGray
        cell.msgLabel.text = self.tempMsg[indexPath.item]
        cell.borderWidthV = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height <= 1334{
                label.font = UIFont.systemFont(ofSize: 14)
            }
        }
        label.text = self.tempMsg[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sendMessage(messageText: self.tempMsg[indexPath.item], lat: 0, long: 0, socketCheck: ControlSettings.socketChat)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    }
    
}

extension ChatScreenVC: UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate  {
    
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            print("URl of audio is \(getFileURL())")
            let sourceUrl = getFileURL()
            let documentsDirectory = getDocumentsDirectory()
            let destUrl = documentsDirectory.appendingPathComponent("converted.wav")
            convertAudio(sourceUrl, outputURL: destUrl)
            guard let data = try? Data(contentsOf: destUrl) else {
                log.verbose("unsucessfull to convert audio into data")
                return
            }
            self.sendSelectedData(audioData: data, imageData: nil, videoData: nil, imageMimeType: nil, VideoMimeType: nil, audioMimeType: data.mimeType, Type: "audio", fileData: nil, fileExtension: nil, FileMimeType: nil)
            
        } else {
            log.verbose("Failed to recoed audio message")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: - UILongPressGestureRecognizer Action -
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began
        {
            sendBtn.setImage(UIImage(named: "ic_microphone"), for: .normal)
            self.startRecording()
            print("this is recording the audio")
        }
        else if gestureReconizer.state == UIGestureRecognizer.State.ended {
            sendBtn.setImage(UIImage(named: "ic_send"), for: .normal)
            self.finishRecording(success: true)
            print("ended")
        }
    }
    
    fileprivate func setupAudioMessageConfig() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        sendBtn.addGestureRecognizer(lpgr)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func reportError(error: OSStatus) {
        // Handle error
    }
    
    
    func convertAudio(_ url: URL, outputURL: URL) {
        var error : OSStatus = noErr
        var destinationFile: ExtAudioFileRef? = nil
        var sourceFile : ExtAudioFileRef? = nil
        
        var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        
        ExtAudioFileOpenURL(url as CFURL, &sourceFile)
        
        var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))
        
        ExtAudioFileGetProperty(sourceFile!,
                                kExtAudioFileProperty_FileDataFormat,
                                &thePropertySize, &srcFormat)
        
        dstFormat.mSampleRate = 44100  //Set sample rate
        dstFormat.mFormatID = kAudioFormatLinearPCM
        dstFormat.mChannelsPerFrame = 1
        dstFormat.mBitsPerChannel = 16
        dstFormat.mBytesPerPacket = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mBytesPerFrame = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mFramesPerPacket = 1
        dstFormat.mFormatFlags = kLinearPCMFormatFlagIsPacked |
            kAudioFormatFlagIsSignedInteger
        
        // Create destination file
        error = ExtAudioFileCreateWithURL(
            outputURL as CFURL,
            kAudioFileWAVEType,
            &dstFormat,
            nil,
            AudioFileFlags.eraseFile.rawValue,
            &destinationFile)
        print("Error 1 in convertAudio: \(error.description)")
        
        error = ExtAudioFileSetProperty(sourceFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        print("Error 2 in convertAudio: \(error.description)")
        
        error = ExtAudioFileSetProperty(destinationFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        print("Error 3 in convertAudio: \(error.description)")
        
        let bufferByteSize : UInt32 = 32768
        var srcBuffer = [UInt8](repeating: 0, count: 32768)
        var sourceFrameOffset : ULONG = 0
        
        while(true){
            var fillBufList = AudioBufferList(
                mNumberBuffers: 1,
                mBuffers: AudioBuffer(
                    mNumberChannels: 2,
                    mDataByteSize: UInt32(srcBuffer.count),
                    mData: &srcBuffer
                )
            )
            var numFrames : UInt32 = 0
            
            if(dstFormat.mBytesPerFrame > 0){
                numFrames = bufferByteSize / dstFormat.mBytesPerFrame
            }
            
            error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
            print("Error 4 in convertAudio: \(error.description)")
            
            if(numFrames == 0){
                error = noErr;
                break;
            }
            
            sourceFrameOffset += numFrames
            error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
            print("Error 5 in convertAudio: \(error.description)")
        }
        
        error = ExtAudioFileDispose(destinationFile!)
        print("Error 6 in convertAudio: \(error.description)")
        error = ExtAudioFileDispose(sourceFile!)
        print("Error 7 in convertAudio: \(error.description)")
    }
}

extension CMTime {
    var durationText:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}


extension AVPlayer {
    func generateThumbnail(time: CMTime) -> UIImage? {
        guard let asset = currentItem?.asset else { return nil }
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

extension ChatScreenVC: sendLocationProtocol  {
    func sendLocation(lat: Double, long: Double) {
        self.sendMessage(messageText: "", lat: lat, long: long, socketCheck: ControlSettings.socketChat)
    }
}
