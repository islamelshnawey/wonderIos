
import UIKit
import Toast_Swift
import JGProgressHUD
import SwiftEventBus
import ContactsUI
import Async
import OneSignal
import WoWonderTimelineSDK
import BSImagePicker
import Photos
import GoogleMobileAds
import CommonCrypto
import UIKit
import WoWonderTimelineSDK
import OneSignal

class BaseVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tempMsg = ["Hi","Hello", "Hello there can we talk?","How you doing", "You there?"]
    var hud : JGProgressHUD?
    
    private var noInternetVC: NoInternetDialogVC!
    var userId:String? = nil
    var sessionId:String? = nil
    var contactNameArray = [String]()
    var contactNumberArray = [String]()
    var deviceID:String? = ""
    var oneSignalID:String? = ""

    //For imagePicker
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    let imagePicker = ImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        oneSignalID = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
                    print("Current playerId \(oneSignalID)")
                    UserDefaults.standard.setDeviceId(value: oneSignalID ?? "", ForKey: "deviceID")
        oneSignalID = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        print("Current playerId \(oneSignalID)")
        UserDefaults.standard.setDeviceId(value: oneSignalID ?? "", ForKey: Local.DEVICE_ID.DeviceId)
        self.dismissKeyboard()
        
        
        oneSignalID =  UserDefaults.standard.getDeviceId(Key: "deviceID")

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        
//        self.deviceID = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
//        noInternetVC = R.storyboard.main.noInternetDialogVC()
//
//        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
//            self.CheckForUserCAll()
//            log.verbose("Internet connected!")
//            self.noInternetVC.dismiss(animated: true, completion: nil)
            
        }
    
        

        //Internet connectivity event subscription
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
                self.present(self.noInternetVC, animated: true, completion: nil)

        }
        
        if ControlSettings.socketChat{
            SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_CONNECT_SOCKET_CALL) { result in

               let checkStatus =  SocketIOManager.sharedInstance.checkStatus()
                if checkStatus {
                    ["username":AppInstance.instance.userProfile?.username ?? "","user_id" : AppInstance.instance.sessionId ?? ""]
                    SocketIOManager.sharedInstance.sendJoin(message: SocketEvents.SocketEventconstantsUtils.EVENT_JOIN, username: AppInstance.instance.userProfile?.username ?? "", userID: AppInstance.instance.sessionId ?? "")
//                    SocketIOManager.sharedInstance.sendJoin(message: SocketEvents.SocketEventconstantsUtils.EVENT_JOIN, withNickname: )
                    SwiftEventBus.unregister(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_CONNECT_SOCKET_CALL)
                }else{

                }

            }
        }else{
            log.verbose("Socket Chat not true")
        }
       
    
    }
//    deinit {
//        SwiftEventBus.unregister(self)
//    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        //..
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        //..
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
//        if !Connectivity.isConnectedToNetwork() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
////                self.present(self.noInternetVC, animated: true, completion: nil)
//            })
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func decryptionAESModeECB(messageData: String, key: String) -> String? {
        let dataKey = Data(messageData.utf8)
        guard let messageString = String(data: dataKey, encoding: .utf8) else { return nil }
        guard let data = Data(base64Encoded: messageString, options: .ignoreUnknownCharacters) else { return nil }
        guard let keyData = key.data(using: String.Encoding.utf8) else { return nil }
        guard let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) else { return nil }
        
        let keyLength               = size_t(kCCKeySizeAES128)
        let operation:  CCOperation = UInt32(kCCDecrypt)
        let algoritm:   CCAlgorithm = UInt32(kCCAlgorithmAES)
        let options:    CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let iv:         String      = ""
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  (keyData as NSData).bytes, keyLength,
                                  iv,
                                  (data as NSData).bytes, data.count,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        if cryptStatus < 0{
            return nil
        }else{
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let str = String(decoding : (cryptData as Data?)!, as: UTF8.self)
                if str == nil{
                    return messageData
                }else{
                    return str
                }
           
            } else {
                return messageData
            }
        }
       
    }
    func getUserSession(){
        log.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
        let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
        
        self.userId = localUserSessionData[Local.USER_SESSION.User_id] as! String
        self.sessionId = localUserSessionData[Local.USER_SESSION.Access_token] as! String
    }
    func showProgressDialog(text: String) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = text
        hud?.show(in: self.view)
    }
    
    func dismissProgressDialog(completionBlock: @escaping () ->()) {
          hud?.dismiss()
        completionBlock()
      
    }
    
    func fetchContacts(){
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        self.contactNameArray.append(contact.givenName)
                        self.contactNumberArray.append(number.stringValue)
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                    }
                }
            }
            print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                image = result ?? UIImage()
            })
            return image
    }
    
    func setLocalDate(timeStamp: String?) -> String{
        guard let time = timeStamp else { return "" }
        let localTime = Double(time) //else { return ""}
        let date = Date(timeIntervalSince1970: localTime ?? 0.0)
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "HH:mm"
        let dateString = format.string(from: date)
        return dateString
    }
    
    private func CheckForUserCAll(){
        Async.background({
            GetUserListManager.instance.getUserList(user_id: AppInstance.instance.userId ?? "", session_Token: AppInstance.instance.sessionId ?? "") { (success,roomName,callId,senderName,senderProfileImage,callingType,acessToken2, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            guard let data = success?["data"] as? [[String:Any]] else{return}
                            guard let status = success?["api_status"] as? Int else{return}
                            guard let videoCall = success?["video_call"] as? Bool else{return}
                            guard let audioCall = success?["audio_call"] as? Bool else{return}
                            guard let agoraCall = success?["agora_call"] as? Bool else{return}
                            log.debug("userList = \(agoraCall ?? false)")
                            let alert = UIAlertController(title: NSLocalizedString("Calling", comment: "Calling"), message: NSLocalizedString("someone is calling you", comment: "someone is calling you"), preferredStyle: .alert)
                            if agoraCall == true{
                               
                                let answer = UIAlertAction(title: NSLocalizedString("Answer", comment: "Answer"), style: .default, handler: { (action) in
                                    log.verbose("Answer Call")
                                   let vc = R.storyboard.call.videoCallVC()
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                })
                                let decline = UIAlertAction(title: NSLocalizedString("Decline", comment: "Decline"), style: .default, handler: { (action) in
                                    log.verbose("Call decline")
                                    log.verbose("Room name = \(roomName)")
                                    log.verbose("CallID = \(callId)")
                                })
                                alert.addAction(answer)
                                alert.addAction(decline)
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                alert.dismiss(animated: true, completion: nil)
                                log.verbose("There is no call to answer..")
                            }
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            //self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            //self.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            //self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            }
            
        })
        
    }
    
    
  //  var oneSignalID:String? = ""
    
    func convertTime(miliseconds: Int) -> String {

        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var secondsTemp: Int = 0
        var minutesTemp: Int = 0
        var hoursTemp: Int = 0

        if miliseconds < 1000 {
            return ""
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return "\(seconds) seconds"
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            return "\(minutes) minutes, \(seconds) seconds"
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(hours) hours, \(minutes) minutes, \(seconds) seconds"
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(days) days, \(hours) hours, \(minutes) minutes, \(seconds) seconds"
        }
    }

}
