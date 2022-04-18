

import UIKit
import AgoraRtcKit
import Async
import WoWonderTimelineSDK

class AgoraCallVC:BaseVC {
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var controlButtonsView: UIView!
    
    var agoraKit: AgoraRtcEngineKit!
    var callId:Int? = 0
    var roomID:String? = ""
    var profileImageUrlString:String? = ""
    var usernameString:String? = ""
    private var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        initializeAgoraEngine()
        joinChannel()
        self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId:ControlSettings.agoraCallingToken, delegate: nil)
    }
    
    func joinChannel() {
        agoraKit.joinChannel(byToken: nil, channelId: "\(self.callId!)", info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        let callIdConverted = "\(callId!)"
        if ControlSettings.agoraCall == true && ControlSettings.twilloCall == false{
            self.declineCall(callID: callIdConverted)
        }else{
            self.twilloDeclineCall(callID: callIdConverted)
        }
        
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        hideControlButtons()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func hideControlButtons() {
        controlButtonsView.isHidden = true
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.setEnableSpeakerphone(sender.isSelected)
    }
    private func setupUI(){
        self.usernameLabel.text = self.usernameString ?? ""
        let url = URL.init(string:profileImageUrlString ?? "")
       self.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
    }
    private func declineCall(callID:String){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            CallManager.instance.agoraCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
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
    private func twilloDeclineCall(callID:String){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        Async.background({
            TwilloCallmanager.instance.twilloAudioCallAction(user_id: userId, session_Token: sessionID, call_id: callID, answer_type: "decline", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
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
    @objc func update() {
        self.checkForCallAction(callID: self.callId!)
        
    }
    private func checkForCallAction(callID:Int){
        let userId = AppInstance.instance.userId ?? ""
        let sessionID = AppInstance.instance.sessionId ?? ""
        if ControlSettings.agoraCall == true && ControlSettings.twilloCall == false{
            Async.background({
                CallManager.instance.checkForAgoraCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: "", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.callStatus ?? nil)")
                                
                                if success?.callStatus == "declined"{
                                    self.navigationController?.popViewController(animated: true)
                                    self.leaveChannel()
                                    self.timer.invalidate()
                                    log.verbose("Call Has Been Declined")
                                }else if success?.callStatus == "answered"{
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.callStatus == "no_answer"{
                                    self.navigationController?.popViewController(animated: true)
                                    self.leaveChannel()
                                    self.timer.invalidate()
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
                TwilloCallmanager.instance.checkForTwilloCall(user_id: userId, session_Token: sessionID, call_id: callID, call_Type: "audio", completionBlock: { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("userList = \(success?.callStatus ?? nil)")
                                
                                if success?.callStatus == 400{ self.navigationController?.popViewController(animated: true)
                                    self.leaveChannel()
                                    self.timer.invalidate()
                                    log.verbose("Call Has Been Declined")
                                }else if success?.callStatus == 200{
                                    log.verbose("Call Has Been Answered")
                                }else if  success?.callStatus == 300{
                                    
                                    log.verbose("calling")
                                    
                                }else{
                                    self.dismiss(animated: true, completion: nil)
                                    self.leaveChannel()
                                    self.timer.invalidate()
                                    log.verbose("No answer")
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
