

import UIKit
import Async
import SwiftEventBus
import AVFoundation
import AVKit
import WoWonderTimelineSDK

class AgoraCallNotificationPopupVC: BaseVC {

    @IBOutlet weak var callingLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var callUserObject:GetUserListModel.Datum?
    var contactUserObject:SelectContactModel.User?
    var callLogUserObject:CallLogsModel?
    var searchUserObject:SearchModel.User?
    var followingUserObject:FollowingModel.Following?
    var callingType:String? = ""
    var callingStatus:String? = ""
    var delegate:CallReceiveDelegate?
    private var callId:Int? = 0
    private var timer = Timer()
    private var accessTokenID = ""
    private var roomId:String? = ""
    private var callAudioPlayer: AVAudioPlayer?
    private var callingStyle:String? = ""
    var isDialer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if isDialer {
            //change sound according to the project
            self.playCallSoundSound()
        }else {
            self.playCallSoundSound()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CallUser()
    }
   
    deinit {
        timer.invalidate()
    }
    
    @IBAction func hangupPressed(_ sender: Any) {
        let convertedCallID = "\(self.callId!)"
        self.declineCall(callID: convertedCallID)
    }
    
    @IBAction func soundMutePressed(_ sender: Any) {
    }
    private func setupUI(){
        if self.callUserObject != nil{
            fullNameLabel.text = callUserObject?.name ?? ""
            let url = URL.init(string:callUserObject?.avatar ?? "")
            profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        }else if contactUserObject != nil{
             fullNameLabel.text = contactUserObject?.name ?? ""
            let url = URL.init(string:contactUserObject?.avatar ?? "")
            profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            
        }else if callLogUserObject != nil{
             fullNameLabel.text = callLogUserObject?.name ?? ""
            let url = URL.init(string:callLogUserObject?.profilePicture ?? "")
            profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            
        }else if searchUserObject != nil{
            
             fullNameLabel.text = searchUserObject?.name ?? ""
            let url = URL.init(string: searchUserObject?.avatar ?? "")
            profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        }else{
             fullNameLabel.text = followingUserObject?.name ?? ""
            let url = URL.init(string:followingUserObject?.avatar ?? "")
            profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            
        }
        
        
        self.callingLabel.text = self.callingType ?? ""
    
        profileImage.cornerRadiusV = (profileImage.frame.height) / 2
        let dismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:)))
        self.view.addGestureRecognizer(dismissView)
       
        
    }
@objc func dismissView(sender: UITapGestureRecognizer) {
    self.dismiss(animated: true, completion: nil)
}
    func playCallSoundSound() {
        guard let url = Bundle.main.url(forResource: "mystic_call", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            callAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            callAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = callAudioPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func CallUser(){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        var recipientID = ""
        if self.callUserObject != nil{
           recipientID = callUserObject?.userID ?? ""
        }else if contactUserObject != nil{
         recipientID = contactUserObject?.userID ?? ""
            
        }else if callLogUserObject != nil{
          
            recipientID = callLogUserObject?.userId ?? ""
        }else if searchUserObject != nil{
            recipientID = searchUserObject?.userID ?? ""
        }else{
            
            recipientID = followingUserObject?.userID ?? ""
        }
        
        if ControlSettings.agoraCall == true &&  ControlSettings.twilloCall == false{
             self.callingStyle = "agora"
            if callingStatus == "video"{
                Async.background({
                    CallManager.instance.agoraCall(user_id: userId, session_Token: sessionID, recipient_Id: recipientID, call_Type: "video", completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.roomName ?? nil)")
                                    self.callId = success?.id!
                                    self.roomId = success?.roomName ?? nil
                                    log.verbose("self.callId = \(self.callId)")
                                    self.checkForCallAction(callID: self.callId!, callingStatus: self.callingStyle!, accessToken: "")
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
                    CallManager.instance.agoraCall(user_id: userId, session_Token: sessionID, recipient_Id: recipientID, call_Type: "audio", completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.id ?? nil)")
                                    self.callId = success?.id!
                                    self.roomId = success?.roomName ?? nil
                                   
                                    self.checkForCallAction(callID: self.callId!, callingStatus: self.callingStyle!, accessToken: "")
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                                    
                                    
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
        }else{
            if callingStatus == "video"{
                 self.callingStyle = "twillo"
                Async.background({
                    //This is for video
                    TwilloCallmanager.instance.twilloVideoCall(user_id: userId, session_Token: sessionID, recipient_Id: recipientID, completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.roomName ?? nil)")
                                    self.callId = success?.id!
                                    self.roomId = success?.roomName ?? nil
                                    self.accessTokenID = (success?.accessToken)!
                                    log.verbose("self.callId = \(self.callId)")
                                    log.verbose("AccessToken = \(success?.accessToken ?? "")")
                                    log.verbose("AccessToken = \(success?.accessToken2 ?? "")")
                                    
                                    //Yahn dosra kea hai
                                    sleep(8)
                                    self.checkForCallAction(callID: self.callId!, callingStatus: self.callingStyle!, accessToken: (success?.accessToken2)!)
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
                    //This is for audio
                    TwilloCallmanager.instance.twilloCall(user_id: userId, session_Token: sessionID, recipient_Id: recipientID, completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.id ?? nil)")
                                    self.callId = success?.id!
                                    self.roomId = success?.roomName ?? nil
                                    self.accessTokenID = (success?.accessToken)!
                                    sleep(8)
                                    self.checkForCallAction(callID: self.callId!, callingStatus: self.callingStyle!, accessToken: (success?.accessToken2)!)
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                                    
                                    
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
    
    private func checkForCallAction(callID:Int,callingStatus:String,accessToken:String){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
         var recipientID  = ""
        if self.callUserObject != nil{
            recipientID = callUserObject?.userID ?? ""
        }else if contactUserObject != nil{
            recipientID = contactUserObject?.userID ?? ""
            
        }else if callLogUserObject != nil{
            
            recipientID = callLogUserObject?.userId ?? ""
        }else if searchUserObject != nil{
            recipientID = searchUserObject?.userID ?? ""
        }else{
            
            recipientID = followingUserObject?.userID ?? ""
        }
        
      
        if callingStatus == "agora"{
            Async.background({
                CallManager.instance.checkForAgoraCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: "", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.callStatus ?? nil)")
                                
                                if success?.callStatus == "declined"{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    self.setCallLogs(callActionMessage: "cancelled")
                                    log.verbose("Call Has Been Declined")
                                }else if success?.callStatus == "answered"{
                                    if self.callingStatus! == "video"{
                                        self.dismiss(animated: true, completion: {
                                            var username = ""
                                            var profilePicture = ""
                                            if self.callUserObject != nil{
                                                
                                                username = self.callUserObject?.username ?? ""
                                                profilePicture = self.callUserObject?.avatar ?? ""
                                                
                                            }else if self.contactUserObject != nil{
                                                
                                                username = self.contactUserObject?.username ?? ""
                                                profilePicture = self.contactUserObject?.avatar ??  ""
                                                
                                            }else if self.callLogUserObject != nil{
                                                
                                                username =  self.callLogUserObject?.name ?? ""
                                                profilePicture = self.callLogUserObject?.profilePicture ?? ""
                                                
                                            }else if self.searchUserObject != nil{
                                                
                                                username = self.searchUserObject?.username ?? ""
                                                profilePicture =  self.searchUserObject?.avatar ?? ""
                                                
                                            }else{
                                                
                                                username = self.followingUserObject?.username ?? ""
                                                profilePicture = self.followingUserObject?.avatar ?? ""
                                            }
                                            
                                            self.delegate?.receiveCall(callId: callID, RoomId: self.roomId ?? "", callingType: self.callingStatus ?? "", username:username ,profileImage:profilePicture, accessToken: "")
                                            self.setCallLogs(callActionMessage: "video call answered")
                                            
                                            self.timer.invalidate()
                                            
                                        })
                                        
                                    }else{
                                        self.dismiss(animated: true, completion: {
                                            var username = ""
                                            var profilePicture = ""
                                            if self.callUserObject != nil{
                                                
                                                username = self.callUserObject?.username ?? ""
                                                profilePicture = self.callUserObject?.avatar ?? ""
                                                
                                            }else if self.contactUserObject != nil{
                                                
                                                username = self.contactUserObject?.username ?? ""
                                                profilePicture = self.contactUserObject?.avatar ??  ""
                                                
                                            }else if self.callLogUserObject != nil{
                                                
                                                username =  self.callLogUserObject?.name ?? ""
                                                profilePicture = self.callLogUserObject?.profilePicture ?? ""
                                                
                                            }else if self.searchUserObject != nil{
                                                
                                                username = self.searchUserObject?.username ?? ""
                                                profilePicture =  self.searchUserObject?.avatar ?? ""
                                                
                                            }else{
                                                
                                                username = self.followingUserObject?.username ?? ""
                                                profilePicture = self.followingUserObject?.avatar ?? ""
                                            }
                                            
                                            self.delegate?.receiveCall(callId: callID, RoomId: self.roomId ?? "", callingType: self.callingStatus ?? "", username:username ,profileImage:profilePicture, accessToken: accessToken)
                                            self.setCallLogs(callActionMessage: "audio call answered")
                                            
                                            self.timer.invalidate()
                                        })
                                    }
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.callStatus == "no_answer"{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    self.setCallLogs(callActionMessage: "No answer")
                                    log.verbose("No Answer")
                                    
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
                TwilloCallmanager.instance.checkForTwilloCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: self.callingStatus ?? "", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.callStatus ?? nil)")
                                
                                if success?.callStatus == 400{
                                    self.dismiss(animated: true, completion: nil)
                                    self.timer.invalidate()
                                    self.setCallLogs(callActionMessage: "cancelled")
                                    log.verbose("Call Has Been Declined")
                                }else if success?.callStatus == 200{
                                    if self.callingStatus! == "video"{
                                        self.dismiss(animated: true, completion: {
                                            var username = ""
                                            var profilePicture = ""
                                            if self.callUserObject != nil{
                                                
                                                username = self.callUserObject?.username ?? ""
                                                profilePicture = self.callUserObject?.avatar ?? ""
                                                
                                            }else if self.contactUserObject != nil{
                                                
                                                username = self.contactUserObject?.username ?? ""
                                                profilePicture = self.contactUserObject?.avatar ??  ""
                                                
                                            }else if self.callLogUserObject != nil{
                                                
                                                username =  self.callLogUserObject?.name ?? ""
                                                profilePicture = self.callLogUserObject?.profilePicture ?? ""
                                                
                                            }else if self.searchUserObject != nil{
                                                
                                                username = self.searchUserObject?.username ?? ""
                                                profilePicture =  self.searchUserObject?.avatar ?? ""
                                                
                                            }else{
                                                
                                                username = self.followingUserObject?.username ?? ""
                                                profilePicture = self.followingUserObject?.avatar ?? ""
                                            }
                                            
                                            self.delegate?.receiveCall(callId: callID, RoomId: self.roomId ?? "", callingType: self.callingStatus ?? "", username:username ,profileImage:profilePicture, accessToken: accessToken)
                                            self.setCallLogs(callActionMessage: "video call answered")
                                            
                                            self.timer.invalidate()
                                            
                                        })
                                        
                                    }else{
                                        self.dismiss(animated: true, completion: {
                                            var username = ""
                                            var profilePicture = ""
                                            if self.callUserObject != nil{
                                                
                                                username = self.callUserObject?.username ?? ""
                                                profilePicture = self.callUserObject?.avatar ?? ""
                                                
                                            }else if self.contactUserObject != nil{
                                                
                                                username = self.contactUserObject?.username ?? ""
                                                profilePicture = self.contactUserObject?.avatar ??  ""
                                                
                                            }else if self.callLogUserObject != nil{
                                                
                                                username =  self.callLogUserObject?.name ?? ""
                                                profilePicture = self.callLogUserObject?.profilePicture ?? ""
                                                
                                            }else if self.searchUserObject != nil{
                                                
                                                username = self.searchUserObject?.username ?? ""
                                                profilePicture =  self.searchUserObject?.avatar ?? ""
                                                
                                            }else{
                                                
                                                username = self.followingUserObject?.username ?? ""
                                                profilePicture = self.followingUserObject?.avatar ?? ""
                                            }
                                            
                                            self.delegate?.receiveCall(callId: callID, RoomId: self.roomId ?? "", callingType: self.callingStatus ?? "", username:username ,profileImage:profilePicture, accessToken: accessToken)
                                            self.setCallLogs(callActionMessage: "audio call answered")
                                            
                                            self.timer.invalidate()
                                        })
                                    }
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.callStatus == 300{
                                    log.verbose("Calling")
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
    @objc func update() {
        
        self.checkForCallAction(callID: self.callId!, callingStatus: callingStyle!, accessToken: self.accessTokenID)
       
    }
    
    private func declineCall(callID:String){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        if self.callingStyle == "agora"{
            Async.background({
                CallManager.instance.agoraCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.status ?? nil)")
                                self.dismiss(animated: true, completion: {
                                    self.timer.invalidate()
                                })
                                
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
            if self.callingStatus == "video"{
                Async.background({
                    TwilloCallmanager.instance.twilloVideoCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.status ?? nil)")
                                    self.dismiss(animated: true, completion: {
                                        self.timer.invalidate()
                                    })
                                    
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
                    TwilloCallmanager.instance.twilloAudioCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("userList = \(success?.status ?? nil)")
                                    self.dismiss(animated: true, completion: {
                                        self.timer.invalidate()
                                    })
                                    
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
    private func setCallLogs(callActionMessage:String?){
        log.verbose("Check = \(UserDefaults.standard.getCallsLogs(Key: Local.CALL_LOGS.CallLogs))")
        var name = ""
        var profilePicture = ""
        var userId = ""
        var username = ""
        if self.callUserObject != nil{
            
            name = self.callUserObject?.name ?? ""
            profilePicture = self.callUserObject?.avatar ?? ""
            userId = self.callUserObject?.userID  ?? ""
            username = self.callUserObject?.username  ?? ""
            
        }else if contactUserObject != nil{
            
            name = self.contactUserObject?.name ?? ""
            profilePicture = self.contactUserObject?.avatar ??  ""
            userId = self.contactUserObject?.userID ?? ""
             username = self.contactUserObject?.username  ?? ""
            
        }else if callLogUserObject != nil{
            
            name =  self.callLogUserObject?.name ?? ""
            profilePicture = self.callLogUserObject?.profilePicture ?? ""
            userId =  self.callLogUserObject?.userId ?? ""
             username = self.callLogUserObject?.name  ?? ""
            
        }else if searchUserObject != nil{
            
            name = self.searchUserObject?.name ?? ""
            profilePicture =  self.searchUserObject?.avatar ?? ""
            userId = searchUserObject?.userID ??  ""
             username = self.searchUserObject?.username  ?? ""
            
        }else{
            
            name = followingUserObject?.name ?? ""
            profilePicture = followingUserObject?.avatar ?? ""
            userId =  followingUserObject?.userID ?? ""
             username = self.followingUserObject?.username  ?? ""
        }
        
        let callLogsObject = CallLogsModel(userId: userId, name:name, profilePicture:profilePicture, logText:callActionMessage ?? "",type:callingStatus)
            let objectToEncode = callLogsObject
            let data = try? PropertyListEncoder().encode(objectToEncode)
            var getCallLogsData = UserDefaults.standard.getCallsLogs(Key: Local.CALL_LOGS.CallLogs)
            getCallLogsData.append(data!)
            UserDefaults.standard.setCallLogs(value: getCallLogsData, ForKey: Local.CALL_LOGS.CallLogs)
            
    }
}
