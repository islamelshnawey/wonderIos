

import UIKit
import Async
import SwiftEventBus
import DropDown
import AVFoundation
import AVKit
import ActionSheetPicker_3_0
import WoWonderTimelineSDK
//import IQKeyboardManagerSwift

class GroupChatScreenVC: BaseVC {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var showAudioCancelBtn: UIButton!
    @IBOutlet weak var showAudioPlayBtn: UIButton!
    @IBOutlet weak var showAudioView: UIView!
    @IBOutlet weak var microBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    var groupOBject:FetchGroupModel.Datum?
    var parts = [FetchGroupModel.UserData]()
    var recipientID:String? = ""
    var groupId:String? = ""
    var audioPlayer = AVAudioPlayer()
    var chatColorHex:String? = ""
    var groupname:String? = ""
    var index:Int? = 0
    var groupImage:String? = ""
    private var messagesArray = [GroupChatModel.Message]()
    private var stopArray = [UserChatModel.Message]()
    private var userChatCount:Int? = 0
    private var player = AVPlayer()
    private var playerItem:AVPlayerItem!
    private var playerController = AVPlayerViewController()
    private let imagePickerController = UIImagePickerController()
    private let MKColorPicker = ColorPickerViewController()
    private var sendMessageAudioPlayer: AVAudioPlayer?
    private var receiveMessageAudioPlayer: AVAudioPlayer?
    private var toneStatus: Bool? = false
    private var scrollStatus:Bool? = true
    private var messageCount:Int? = 0
    private var admin:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
        self.fetchUserProfile()
        self.textViewPlaceHolder()
        let messageTextFrame = self.messageTxtView.frame.height / 3
        self.messageTxtView.textContainerInset = UIEdgeInsets(top: messageTextFrame, left: 13, bottom: messageTextFrame, right: 13)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
       // IQKeyboardManager.shared.enable = false
        let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

//        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
//            self.fetchData()
//
//        }
//        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
//            log.verbose("Internet dis connected!")
//        }
    }
    
    
    @objc func update() {
        self.fetchData()
    }
    
    deinit {
        SwiftEventBus.unregister(self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // IQKeyboardManager.shared.enable = true
        self.navigationController?.isNavigationBarHidden = false
        SwiftEventBus.unregister(self)
    }
    
    @objc override func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        //Check the device height
        bottomConstraints?.constant = (keyboardFrame!.height + (UIScreen.main.nativeBounds.height >= 2436 ? 80 : 100))
        animatedKeyBoard(scrollToBottom: true)
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        bottomConstraints?.constant = 100
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
                self.presentImagePicker(self.imagePicker, select: { (asset) in
                }, deselect: { (asset) in
                    // User deselected an asset. Cancel whatever you did when asset was selected.
                }, cancel: { (assets) in
                    // User canceled selection.
                }, finish: { (assets) in
                    if !(assets.count > 20){
                        for index in 0..<assets.count{
                            let image = self.getAssetThumbnail(asset: assets[index])
                            let imageData = image.jpegData(compressionQuality: 0.1)
                            self.sendSelectedData(imageData: imageData, videoData: nil, imageMimeType: imageData?.mimeType, VideoMimeType: nil, Type: "image", fileData: nil, fileExtension: nil, FileMimeType: nil)
                        }
                    }else{
                       // let vc = R.storyboard.main.securityPopupVC()
                      //  vc?.titleLabel.text = "Only 20 photos at a time are allowed"
                    }
                })
            }
            
            return
            
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func microPressed(_ sender: Any) {
    }
    
    @IBAction func selectFilePressed(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if self.messageTxtView.text == NSLocalizedString("Your message here...", comment: "Your message here..."){
            log.verbose("will not send message as it is PlaceHolder...")
        }else{
            if messageTxtView.text!.isEmpty {
                log.verbose("will not send message as it is PlaceHolder...")
            }else{
                self.sendMessage()
            }
        }
        
    }
    
    @IBAction func morePressed(_ sender: Any) {
        let vc = R.storyboard.group.updateGroupVC()
        vc?.partsArray  = parts ?? []
        vc?.groupName = self.groupname ?? ""
        vc?.groupImageString = self.groupImage ?? ""
        vc?.groupID = self.groupId ?? ""
        vc?.groupOwner = self.groupOBject?.owner ?? false
        self.navigationController?.pushViewController(vc!, animated: true)
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
    private func fetchData(){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        let groupId = self.groupId ?? ""
        log.verbose("group id = \(groupId)")
        Async.background({
            GroupChatManager.instance.getGroupChats(group_Id: groupId, session_Token: sessionID, type: "fetch_messages", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.messagesArray.removeAll()
                            log.debug("userList = \(success?.data?.messages?.count ?? nil)")
                            for item in stride(from: (success?.data?.messages!.count)! - 1, to: -1, by: -1){
                                self.messagesArray.append((success?.data?.messages![item])!)
                            }
                            self.tableView.reloadData()
                            if self.scrollStatus!{
                                if self.messagesArray.count == 0{
                                    log.verbose("Will not scroll more")
                                }else{
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
    private func sendMessage(){
        self.messagesArray.removeAll()
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTxtView.text ?? ""
        let groupId = self.groupId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        
        Async.background({
            GroupChatManager.instance.sendMessageToGroup(message_hash_id: messageHashId, GroupId: groupId, text: messageText, type: "send", session_Token: sessionID, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if self.messagesArray.count == 0{
                                log.verbose("Will not scroll more")
                                self.messageTxtView.text = ""
                                //                                self.textViewPlaceHolder()
                                self.view.resignFirstResponder()
                            }else{
                                if self.toneStatus!{
                                    self.playSendMessageSound()
                                }else{
                                    log.verbose("To play sound please enable conversation tone from settings..")
                                }
                                self.messageTxtView.text = ""
                                //                                self.textViewPlaceHolder()
                                self.view.resignFirstResponder()
                                log.debug("userList = \(success?.apiStatus ?? 0)")
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
    
    
    private func setFavorite(receipentID:String,ID:String,object:GroupChatModel.Message){
        var data = Data()
        
        let objectToEncode = object
        data = try! PropertyListEncoder().encode(objectToEncode)
        
        log.verbose("Check = \(UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite))")
        var dataDic = UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
        var getfavoriteMessages  =  dataDic[receipentID] ?? []
        if getfavoriteMessages.contains(data){
            for (item,value) in getfavoriteMessages.enumerated(){
                if data == value{
                    self.index = item
                    break
                }
            }
            getfavoriteMessages.remove(at:self.index ?? 0)
            
            dataDic[receipentID] = getfavoriteMessages
            UserDefaults.standard.setFavorite(value: dataDic , ForKey: Local.FAVORITE.favorite)
            self.view.makeToast(NSLocalizedString("remove from favorite", comment: "remove from   favorite"))
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
    
    
    private func setupUI(){
        self.toneStatus = UserDefaults.standard.getConversationTone(Key: Local.CONVERSATION_TONE.ConversationTone)
        //        self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        //        self.statusBarView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        //        self.sendBtn.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
        self.microBtn.isHidden = true
        self.sendBtn.isHidden = false
        self.showAudioView.isHidden = true
        self.usernameLabel.text = groupOBject?.groupName ?? ""
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
        self.adjustHeight()
        self.textViewPlaceHolder()
        
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
    
    
    
}

extension  GroupChatScreenVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let image:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            log.verbose("image = \(image ?? nil)")
            let imageData = image?.jpegData(compressionQuality: 0.1)
            log.verbose("MimeType = \(imageData?.mimeType)")
            sendSelectedData(imageData: imageData, videoData: nil, imageMimeType: imageData?.mimeType, VideoMimeType: nil, Type: "image", fileData: nil, fileExtension: nil, FileMimeType: nil)
            
        }
        
        if let fileURL:URL? = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            if let url = fileURL {
                let videoData = try? Data(contentsOf: url)
                log.verbose("MimeType = \(videoData?.mimeType)")
                print(videoData?.mimeType)
                sendSelectedData(imageData: nil, videoData: videoData, imageMimeType: nil, VideoMimeType: videoData?.mimeType, Type: "video", fileData: nil, fileExtension: nil, FileMimeType: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func sendSelectedData(imageData:Data?,videoData:Data?, imageMimeType:String?,VideoMimeType:String?,Type:String?,fileData:Data?,fileExtension:String?,FileMimeType:String?){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let sessionId = AppInstance.instance.sessionId ?? ""
        let groupId = self.groupId ?? ""
        let dataType = Type ?? ""
        
        if dataType == "image"{
            Async.background({
                GroupChatManager.instance.sendGroupChatData(message_hash_id: messageHashId, groupId: groupId, sendType: "send", session_Token: sessionId, type: dataType, image_data: imageData, video_data: nil, imageMimeType: imageMimeType, videoMimeType: nil, text: "", file_data: nil, file_Extension: nil, fileMimeType: nil, completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.apiStatus ?? 0)")
                                if self.messagesArray.count == 0{
                                    log.verbose("Will not scroll more")
                                    
                                }else{
                                    if self.toneStatus!{
                                        self.playSendMessageSound()
                                    }else{
                                        log.verbose("To play sound please enable conversation tone from settings..")
                                    }
                                    log.debug("userList = \(success?.apiStatus ?? 0)")
                                    let indexPath = NSIndexPath(item: ((self.messagesArray.count) - 1), section: 0)
                                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
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
        }else if dataType == "video"{
            
            Async.background({
                GroupChatManager.instance.sendGroupChatData(message_hash_id: messageHashId, groupId: groupId, sendType: "send", session_Token: sessionId, type: dataType, image_data: nil, video_data: videoData, imageMimeType: nil, videoMimeType: VideoMimeType, text: "", file_data: nil, file_Extension: nil, fileMimeType: nil, completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.apiStatus ?? 0)")
                                if self.messagesArray.count == 0{
                                    log.verbose("Will not scroll more")
                                    
                                }else{
                                    if self.toneStatus!{
                                        self.playSendMessageSound()
                                    }else{
                                        log.verbose("To play sound please enable conversation tone from settings..")
                                    }
                                    log.debug("userList = \(success?.apiStatus ?? 0)")
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
            
        }else{
            Async.background({
                GroupChatManager.instance.sendGroupChatData(message_hash_id: messageHashId, groupId: groupId, sendType: "send", session_Token: sessionId, type: dataType, image_data: nil, video_data: nil, imageMimeType: nil, videoMimeType: nil, text: "", file_data: fileData, file_Extension: fileExtension, fileMimeType: FileMimeType, completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.apiStatus ?? 0)")
                                if self.messagesArray.count == 0{
                                    log.verbose("Will not scroll more")
                                    
                                }else{
                                    if self.toneStatus!{
                                        self.playSendMessageSound()
                                    }else{
                                        log.verbose("To play sound please enable conversation tone from settings..")
                                    }
                                    log.debug("userList = \(success?.apiStatus ?? 0)")
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
}
extension GroupChatScreenVC:SelectContactDetailDelegate {
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
        let groupId = self.groupId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            GroupChatManager.instance.sendContactToGroup(message_hash_id: messageHashId, groupId: groupId, sendType: "send", jsonPayload: jsonPayloadString, session_Token: sessionID, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if self.messagesArray.count == 0{
                                log.verbose("Will not scroll more")
                                
                            }else{
                                if self.toneStatus!{
                                    self.playSendMessageSound()
                                }else{
                                    log.verbose("To play sound please enable conversation tone from settings..")
                                }
                                log.debug("userList = \(success?.apiStatus ?? 0)")
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

extension GroupChatScreenVC: UIDocumentPickerDelegate{
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
            sendSelectedData(imageData: nil, videoData: nil, imageMimeType: nil, VideoMimeType: nil, Type: "file", fileData: fileData, fileExtension: fileExtension, FileMimeType: fileData?.mimeType)
        }
        
        
    }
}
extension GroupChatScreenVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustHeight()
        
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

extension GroupChatScreenVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messagesArray.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier) as? ChatSender_TableCell
            return cell  ?? UITableViewCell()
        }
        
        let object = self.messagesArray[indexPath.row]
        
        if object.media == ""{
            if object.type == "right_text"{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier) as? ChatSender_TableCell
                cell?.selectionStyle = .none
                let paragraph = NSMutableParagraphStyle()
                paragraph.tabStops = [
                    NSTextTab(textAlignment: .right, location: 100, options: [:]),
                ]
                
                var str = "\( (self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "")) ?? object.text ?? "")\n\t\(setLocalDate(timeStamp: object.time))"
                
                if object.seen != "0"{
                    str += "\n\tseen"
                }
                
                let attributed = NSAttributedString(
                    string: str,
                    attributes: [NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.foregroundColor: UIColor.white ,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                )
//                (self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "")) ?? object.text ?? "" + "\n\n\(setLocalDate(timeStamp: object.time))" ?? ""
                
                cell?.messageTxtView.attributedText = attributed
                cell?.messageTxtView.isEditable = false
                //cell?.messageTxtView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
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
            }else if object.type == "left_text"{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiver_TableCell.identifier) as? ChatReceiver_TableCell
                cell?.selectionStyle = .none
                
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
                
                cell?.messageTxtView.text = "\(self.decryptionAESModeECB(messageData: object.text?.htmlAttributedString ?? "", key: object.time ?? "") ?? object.text ?? "")"
                //                cell?.messageTxtView.isEditable = false
                
                return cell!
            }else if object.type == "right_contact"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderContact_TableCell.identifier) as? ChatSenderContact_TableCell
                cell?.selectionStyle = .none
                let data = object.text?.htmlAttributedString!.data(using: String.Encoding.utf8)
                let result = try! JSONDecoder().decode(ContactModel.self, from: data!)
                log.verbose("Result Model = \(result)")
                let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                log.verbose("dictionary = \(dic)")
                cell?.nameLabel.text = "\(dic!["key"] ?? "")"
                cell?.contactLabel.text  =  "\(dic!["value"] ?? "")"
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
                
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
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverContact_TableCell.identifier) as? ChatReceiverContact_TableCell
                cell?.selectionStyle = .none
                log.verbose("object.text?.htmlAttributedString? = \(object.text?.htmlAttributedString)")
                let newString = object.text?.htmlAttributedString!.replacingOccurrences(of: "\\\\", with: "")
                log.verbose("newString= \(newString)")
                let data = object.text?.htmlAttributedString?.data(using: String.Encoding.utf8)
                let result = try! JSONDecoder().decode(ContactModel.self, from: data!)
                let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                log.verbose("dictionary = \(dic)")
                cell?.nameLabel.text = "\(dic!["key"] ?? "")"
                cell?.contactLabel.text  =  "\(dic!["value"] ?? "")"
                
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
                    time += "  seen"
                }
                cell?.timeLabel.text = time
                //cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: self.chatColorHex ?? "#a84849")
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
            }else  if object.type == "right_video"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderImage_TableCell.identifier) as? ChatSenderImage_TableCell
                cell?.selectionStyle = .none
                cell?.fileImage.isHidden = true
                cell?.videoView.isHidden = false
                cell?.playBtn.isHidden = false
                cell?.delegate = self
                cell?.index  = indexPath.row
                cell?.timeLabel.text = object.timeText ?? ""
                
                let videoURL = URL(string: object.media ?? "")
                player = AVPlayer(url: videoURL! as URL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.addChild(playerController)
                playerController.view.frame = self.view.frame
                cell?.videoView.addSubview(playerController.view)
                player.pause()
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
                player.pause()
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
                
            }else if object.type == "right_sticker"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderSticker_TableCel.identifier) as? ChatSenderSticker_TableCell
                cell?.selectionStyle = .none
                let url = URL.init(string:object.media ?? "")
                cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
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
                
                
            }else if object.type == "left_sticker"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverStricker_TableCell.identifier) as? ChatReceiverStricker_TableCell
                cell?.selectionStyle = .none
                let url = URL.init(string:object.media ?? "")
                cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
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
            }else if  object.type == "right_audio"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderAudio_TableCell.identifier) as? ChatSenderAudio_TableCell
                cell?.selectionStyle = .none
                cell?.delegate = self
                cell?.index = indexPath.row
                cell?.url = object.media ?? ""
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
                cell?.timeLabel.text = object.timeText ?? ""
                
                return cell!
            }else if object.type == "left_audio"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverAudio_TableCell.identifier) as? ChatReceiverAudio_TableCell
                cell?.selectionStyle = .none
                cell?.delegate = self
                cell?.index = indexPath.row
                cell?.url = object.media ?? ""
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
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverDocument_TableCell.identifier) as? ChatReceiverDocument_TableCell
                cell?.selectionStyle = .none
                cell?.nameLabel.text = object.mediaFileName ?? ""
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
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIApplication.shared.isKeyboardPresented {
            self.dismissKeyboard()
            return
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
        let index = self.messagesArray[indexPath.row]
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let copy = UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default) { (action) in
            log.verbose("Copy")
            UIPasteboard.general.string = self.messagesArray[indexPath.row].text ?? ""
        }
        let messageInfo = UIAlertAction(title: NSLocalizedString("Message Info", comment: "Message Info"), style: .default) { (action) in
            log.verbose("message Info")
            let vc = R.storyboard.favorite.groupChatInfoVC()
            vc?.object = self.messagesArray[indexPath.row]
            vc?.recipientID = self.recipientID ?? ""
            self.navigationController?.pushViewController(vc!, animated: true)

        }
        let deleteMessage = UIAlertAction(title: NSLocalizedString("Delete Message", comment: "Delete Message"), style: .default) { (action) in
            log.verbose("Delete Message")
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
                guard let vc = R.storyboard.dashboard.showImageVC() else { return }
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
            favoriteMessage = UIAlertAction(title: "Un favorite", style: .default) { (action) in
                log.verbose("favorite message = \(indexPath.row)")
                self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row])
            }

        }else{
            favoriteMessage = UIAlertAction(title: "Favorite", style: .default) { (action) in
                log.verbose("favorite message = \(indexPath.row)")
                self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row])
            }

        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        if (index.productID == nil){
            //            alert.addAction(forwardMessage)
            alert.addAction(favoriteMessage!)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)

        }
        else{
            if (index.media != ""){
                alert.addAction(view)
            }
            alert.addAction(copy)
            alert.addAction(messageInfo)
            alert.addAction(deleteMessage)
            alert.addAction(forwardMessage)
            alert.addAction(favoriteMessage!)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension GroupChatScreenVC:PlayVideoDelegate{
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
extension GroupChatScreenVC:PlayAudioDelegate{
    func playAudio(index: Int, status: Bool, url: URL, button: UIButton) {
        if status{
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!//since it sys
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            log.verbose("destinationUrl is = \(destinationUrl)")
            
            self.playerItem = AVPlayerItem(url: destinationUrl)
            self.player=AVPlayer(playerItem: self.playerItem)
            let playerLayer=AVPlayerLayer(player: self.player)
            self.player.play()
            
            
            self.player.play()
            button.setImage(R.image.ic_pauseBtn(), for: .normal)
        }else{
            self.player.pause()
            button.setImage(R.image.ic_playBtn(), for: .normal)
        }
        
        
    }
}





