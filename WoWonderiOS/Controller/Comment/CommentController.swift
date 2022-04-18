

import UIKit
import Kingfisher
import Toast_Swift
import WoWonderTimelineSDK
import ZKProgressHUD
import iRecordView
import AVFoundation
import Foundation


class CommentController: UIViewController,UITextViewDelegate,uploadImageDelegate,AddReactionDelegate,editCommentDelegate,RecordViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate{
    
    func onStart() {
       
        if isAudioRecordingGranted == false {
           
            let alertController = UIAlertController (title: NSLocalizedString("Allow Microphone Access to record audio?", comment: "Allow Microphone Access to record audio?"), message: NSLocalizedString("Go to Settings", comment: "Go to Settings"), preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                        AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                            if allowed {
                                self.isAudioRecordingGranted = true
                            } else {
                                self.isAudioRecordingGranted = false
                            }
                        })
                        
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel") , style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
        
        else{
            print("Start")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isrecording = "1"
                self.setup_recorder()
//                self.audioRecorder?.record()
            }
            self.recordView.isSoundEnabled = true
            self.commentText.isHidden = true
            self.imageBtn.isHidden = true
            self.sendBtn.isHidden = true
        }
    }
    
    func onCancel() {
        print("onCancel")
        self.isrecording = "0"
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
//                if "\(self.bookId).\(fileURL.pathExtension)" == "\(self.bookId).m4a" {
//                    try FileManager.default.removeItem(at: fileURL)
//                }
            }
        } catch  { print(error) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { // Change `2.0` to the
            self.commentText.isHidden = false
            self.imageBtn.isHidden = false
            self.sendBtn.isHidden = false
            self.audioPlayer.play()
        }
        
    }
    
    func onFinished(duration: CGFloat) {
        if (self.isrecording == "1"){
        self.finishAudioRecording(success: true)
            print("onFinished \(duration)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { // Change `2.0` to the
                self.commentText.isHidden = false
                self.imageBtn.isHidden = false
                self.sendBtn.isHidden = false
                self.isrecording = "0"
            }
        }
    }
    
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var noCommentView: UIView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet var noCommentLbl: UILabel!
    @IBOutlet var recordButton: RecordButton!
    @IBOutlet var noCommentImage: UIImageView!
    var audioRecorder: AVAudioRecorder?
    var isAudioRecordingGranted: Bool?
    
    let recordView = RecordView()
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "click_sound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var player = AVAudioPlayer()
    
    var comments = [[String:Any]]()
    var deleagte: comment_CountsDelegate?
    
    let status = Reach().connectionStatus()
    
    var postId: String? = nil
    var offset = ""
    var likes = 0
    var isImage = false
    var selectedIndex = 0
    var selectedIndexs = [[String:Any]]()
    var commentStatus = "1"
    var isrecording = "0"
    var audioData: Data? = nil
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    var counter = 0
    var timer = Timer()
    var audioIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("commt",comments)
        self.tableView.register(UINib(nibName: "CommentCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        self.player.delegate = self
        self.noCommentView.isHidden = true
        self.recordButton.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.tableView.tableFooterView = UIView()
        self.likesCount.text = "\(self.likes)\(" ")\("Reactions")"
        self.commentText.text = NSLocalizedString("Add a comment here", comment: "Add a comment here")
        self.noCommentLbl.text = NSLocalizedString("No Comments to be displayed", comment: "No Comments to be displayed")
        self.tableView.reloadData()
        self.getComments()
        self.commentText.delegate = self
        self.sendBtn.isEnabled = false
        if (self.commentStatus == "0"){
            self.imageBtn.isHidden = true
            self.sendBtn.isHidden = true
            self.commentText.isHidden = true
            self.recordButton.isHidden = true
        }
        self.check_record_permission()
        self.audioPlayer = try! AVAudioPlayer(contentsOf: playRing)
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordView)
        recordView.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -20).isActive = true
        recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        recordView.bottomAnchor.constraint(equalTo: recordButton.bottomAnchor,constant: -10).isActive = true
        recordButton.recordView = recordView
        recordView.delegate = self
//        recordView.isSoundEnabled = true
        recordView.durationTimerColor = .red
        self.noCommentImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
    }
    
    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }
    
    @objc func SetAudioBtn(sender:UIButton){
        
         if isAudioRecordingGranted == false {
 //            self.audioRecorder?.
             let alertController = UIAlertController (title: NSLocalizedString("Allow Microphone Access to record audio?", comment: "Allow Microphone Access to record audio?"), message: NSLocalizedString("Go to Settings", comment: "Go to Settings"), preferredStyle: .alert)
             
             let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: .default) { (_) -> Void in
                 guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                     return
                 }
                 if UIApplication.shared.canOpenURL(settingsUrl) {
                     UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                         print("Settings opened: \(success)") // Prints true
                         AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                             if allowed {
                                 self.isAudioRecordingGranted = true
                             } else {
                                 self.isAudioRecordingGranted = false
                             }
                         })
                         
                     })
                 }
             }
             alertController.addAction(settingsAction)
             let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel") , style: .default, handler: nil)
             alertController.addAction(cancelAction)
             present(alertController, animated: true, completion: nil)
             
         }
    }
    
    @IBAction func Back(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Send(_ sender: Any) {
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            if !self.isImage{
                
                let publisher = ["username":UserData.getUSER_NAME() ?? "","avatar":UserData.getImage() ?? ""]
                let data = ["text":self.commentText.text!,"time":"Just now","c_file":"","record":"","publisher":publisher] as [String : Any]
                self.comments.append(data)
                self.tableView.reloadData()
                self.commentText.resignFirstResponder()
                self.createComment(voice: nil,data: nil)
            }
            else{
                let publisher = ["username":UserData.getUSER_NAME() ?? "","avatar":UserData.getImage() ?? ""]
                let data = ["text":self.commentText.text!,"time":"Just now","c_file":"upload","record":"","publisher":publisher] as [String : Any]
                self.comments.append(data)
                self.tableView.reloadData()
                self.commentText.resignFirstResponder()
                let imageData = self.imageBtn.image(for: .normal)?.jpegData(compressionQuality: 0.1)
                self.createComment(voice: nil,data: imageData)
                
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.commentText.text == NSLocalizedString("Add a comment here", comment: "Add a comment here"){
            self.commentText.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.commentText.text == "" || self.commentText.text.isEmpty == true{
            self.commentText.text = NSLocalizedString("Add a comment here", comment: "Add a comment here")
            self.sendBtn.isEnabled = false
            self.sendBtn.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
        }
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        //        print(self.commentText.text)
        if self.commentText.text.count > 0{
            self.sendBtn.isEnabled = true
            self.sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        }
        else {
            self.sendBtn.isEnabled = false
            self.sendBtn.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
        }
    }
    
    func uploadImage(imageType: String, image: UIImage) {
        self.imageBtn.setImage(image, for: .normal)
        self.isImage = true
        self.sendBtn.isEnabled = true
        self.sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        self.commentText.resignFirstResponder()
    }
    
    @IBAction func AddImage(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageController
        vc.delegate = self
        vc.imageType = "upload"
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //check_record_permission
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            //      UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL
    {
        let filename = "recording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    //Generalize function for display alert
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    //************************************
    
    //Setup the recorder ********************************************************
    func setup_recorder()
    {
        if isAudioRecordingGranted == true
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                //        try session.setCategory(AVAudioSession.Category.playAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                    AVSampleRateKey: 44100,
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                self.audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.isMeteringEnabled = true
                self.audioRecorder?.prepareToRecord()
                self.audioRecorder?.record()
            }
            catch let error {
                self.view.makeToast(NSLocalizedString("Error", comment: "Error"))
                //                display_alert(msg_title: LocalizedStringForKey(key: "Error"), msg_desc: error.localizedDescription, action_title: LocalizedStringForKey(key:"OK"))
            }
        }
        else
        {
            display_alert(msg_title: NSLocalizedString("Error", comment: "Error"), msg_desc: NSLocalizedString("Don't have access to use your microphone.", comment: "Don't have access to use your microphone."), action_title: NSLocalizedString("OK", comment: "OK"))
        }
    }
    
    func finishAudioRecording(success: Bool){
        self.audioRecorder?.stop()
        if success
        {
            var urlString:String?
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(".mp3") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                    urlString = filePath
                    print(urlString)
//                    self.audioData = NSData(contentsOfFile: urlString ?? "") as Data?
                    self.audioData = NSData(contentsOf: self.audioRecorder!.url) as Data?
                    self.createComment(voice: self.audioData, data: nil)
                }
            }
            print("recorded successfully.")
        }
        else
        {
            self.view.makeToast("Recording failed.")
//            display_alert(msg_title: LocalizedStringForKey(key: "Error"), msg_desc: LocalizedStringForKey(key: "Recording failed."), action_title: LocalizedStringForKey(key:"OK"))
        }
    }
    
    //When recording is finish enable the play button & when play is finish enable the record button
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
//        play_btn_ref.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.timer.invalidate()
        self.counter = 0
        self.player.stop()
        let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 0)) as! CommentCellTableViewCell
        cell.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    private func createComment(voice: Data?,data :Data?){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            var text: String? = nil
            if (self.commentText.text) == NSLocalizedString("Add a comment here", comment: "Add a comment here") || ((self.commentText.text) == "") {
                text = ""
            }
            else{
                text = self.commentText.text
            }
            CreateCommentsManager.sharedInstance.createComment(audio_data: voice, data: data, postId: self.postId ?? "12", text: text ?? "") { (success, authError, error) in
                if (success != nil) {
                    self.commentText.text = NSLocalizedString("Add a comment here", comment: "Add a comment here")
                    self.audioRecorder = nil
                    self.sendBtn.isEnabled = false
                    self.sendBtn.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
                    self.imageBtn.setImage(UIImage(named: "photo"), for: .normal)
                    self.deleagte?.comment_Count()
                    self.commentText.resignFirstResponder()
                    if self.comments.isEmpty == true {
                        self.tableView.isHidden = false
                        self.noCommentView.isHidden = false
                        if (self.commentStatus == "0"){
                            self.noCommentLbl.text = "\(NSLocalizedString("Comments are disabled by", comment: "Comments are disabled by"))\(AppInstance.instance.profile?.userData?.name ?? "")"
                        }
                    }
                    print(success?.data)
//                    self.comments.append(success!.data)
                    let last = self.comments.count - 1
                    self.comments[last] = success!.data
                    self.isImage = false
                    self.tableView.reloadData()
                }
                else if (authError != nil) {
                    self.view.makeToast(authError?.errors.errorText)
                }
                
                else if (error != nil){
                    self.view.makeToast(error?.localizedDescription)
                }
                
            }
        }
    }
    
    private func deleteComment(index:Int,comment_id: Int){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            ZKProgressHUD.show()
            performUIUpdatesOnMain {
                DeleteCommentManager.sharedInstance.deleteComment(comment_id: comment_id) { (success, authError, error) in
                    if (success != nil){
                        ZKProgressHUD.dismiss()
                        self.comments.remove(at: index)
                        self.tableView.reloadData()
                    }
                    else if (authError != nil){
                        ZKProgressHUD.dismiss()
                        self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if (error != nil){
                        ZKProgressHUD.dismiss()
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    func editComment(text: String) {
        print(text)
        self.comments[self.selectedIndex]["text"] = text
        self.tableView.reloadData()
    }
    
    private func reportComment(comment_id: Int){
        ReportCommentManager.sharedInstance.reportComment(comment_id: comment_id) { (success, authError, error) in
            if (success != nil){
                self.view.makeToast(success?.code ?? "")
            }
            else if (authError != nil){
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if error != nil{
                self.view.makeToast(error?.localizedDescription)
            }
        }
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
                        print(self.comments)
                        if (self.comments.isEmpty == true){
                            self.tableView.isHidden = true
                            self.noCommentView.isHidden = false
                            if (self.commentStatus == "0"){
                                self.noCommentLbl.text = "\(NSLocalizedString("Comments are disabled by", comment: "Comments are disabled by"))\(" ")\(AppInstance.instance.profile?.userData?.name ?? "")"
                            }
                        }
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
    
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            let cell = self.tableView.cellForRow(at: IndexPath(row: gesture.view?.tag ?? 0, section: 0)) as! CommentCellTableViewCell
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
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        self.selectedIndex = gesture.view!.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func addReaction(reation: String) {
        print(reation)
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedIndex ?? 0, section: 0)) as! CommentCellTableViewCell
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
    
    func downloadFileFromURL(url:URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URL, response, error) -> Void in
            if error == nil{
                self?.play(url: URL!)
            }
            else{
                print(error?.localizedDescription)
            }
        })
        downloadTask.resume()
    }
    
    func play(url:URL) {
        
        
                    var error : NSError?
                    do {
                        let player = try AVAudioPlayer(contentsOf: url)
                        self.player = player
                     } catch {
                         print(error)
                     }
                          if let err = error{
                              print("audioPlayer error: \(err.localizedDescription)")
                          }else{
                            player.play()
                          }
        
        print("playing \(url)")
        
//        do {
//            self.player = try AVAudioPlayer(contentsOf: url)
////            player.prepareToPlay()
////            player.volume = 1.0
////            player.play()
//
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
//            try AVAudioSession.sharedInstance().setActive(true)
//            self.player.prepareToPlay()
//            player.volume = 1.0
//            player.play()
//
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
    }
    
    @objc func timerAction(){
        let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 0)) as! CommentCellTableViewCell
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
            let cell = tableView.cellForRow(at: IndexPath(row: self.audioIndex, section: 0)) as! CommentCellTableViewCell
            cell.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else{
        self.timer.invalidate()
        self.counter = 0
        self.audioIndex = sender.tag
        self.player.stop()
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommentCellTableViewCell
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
extension CommentController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = self.comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
        cell.noCommentView.isHidden = false
        cell.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        cell.imageHeight.constant = 0.0
        cell.audioViewHeightConstraint.constant = 0.0
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
        if let time = index["time"] as? String{
//            let epocTime = TimeInterval(Int(time) ?? 1601815559)
//            let myDate = NSDate(timeIntervalSince1970: epocTime)
//            let formate = DateFormatter()
//            formate.dateFormat = "H:mm"
////                "yyyy-MM-dd"
//            let dat = formate.string(from: myDate as Date)
//            let da = formate.date(from: dat)
//            print("Date",dat)
//            let time = da!.getElapsedInterval
//            print("Converted Time \(myDate)")
//            cell.commentTime.text = "\(dat)"
//            cell.commentTime.text = time()

            let epocTime = TimeInterval(Int(time) ?? 1601815559)
            let myDate =  Date(timeIntervalSince1970: epocTime)
            let formate = DateFormatter()
            formate.dateFormat = "yyyy-MM-dd"
            cell.commentTime.text = myDate.timeAgoDisplay()
            
        }
        if let image = index["c_file"] as? String{
            if image != ""{
                let prefix = image.prefix(6)
                var img = ""
                if prefix == "upload"{
                    img = "\("https://wowonder.fra1.digitaloceanspaces.com/")\(image)"
                }
                else{
                    img = image
                }
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //                 return 400.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = self.comments[indexPath.row]
        var commentID = ""
        if let commentId = index["id"] as? String{
            commentID = commentId
        }
        let alert = UIAlertController(title: "", message: NSLocalizedString("More", comment: "More"), preferredStyle: .actionSheet)
        if let publisher = index["publisher"] as? [String:Any]{
            if let userId = publisher["user_id"] as? String{
                if let copyText = index["text"] as? String{
                    if copyText != ""{
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Text", comment: "Copy Text"), style: .default, handler: { (_) in
                            UIPasteboard.general.string = copyText
                            self.view.makeToast(NSLocalizedString("Text copied to clipboard", comment: "Text copied to clipboard"))
                        }))
                    }
                }
                alert.addAction(UIAlertAction(title: NSLocalizedString("Report", comment: "Report"), style: .default, handler: { (_) in
                    self.reportComment(comment_id: Int(commentID) ?? 0)
                }))
                if userId == UserData.getUSER_ID(){
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: "Edit"), style: .default, handler: { (_) in
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = Storyboard.instantiateViewController(identifier: "EditCommentVC") as! EditCommentController
                        vc.comment_text = index["text"] as? String ?? ""
                        vc.comment_id =   commentID
                        vc.delegate = self
                        self.selectedIndex = indexPath.row
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete"), style: .default, handler: { (_) in
                        
                        let alert = UIAlertController(title: NSLocalizedString("Delete Comment", comment: "Delete Comment"), message: "Are you sure that you want to delete comment?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                        }))
                        alert.addAction(UIAlertAction(title: "Delete",
                                                      style: UIAlertAction.Style.default,
                                                      handler: {(_: UIAlertAction!) in
                                                        self.deleteComment(index: indexPath.row, comment_id: Int(commentID) ?? 0)
                                                      }))
                        self.present(alert, animated: true, completion: nil)
                    }))
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: nil)
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
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommentCellTableViewCell
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
