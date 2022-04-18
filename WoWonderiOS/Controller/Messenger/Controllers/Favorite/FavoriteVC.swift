

import UIKit
import WoWonderTimelineSDK
import AVFoundation
import AVKit
import Async

class FavoriteVC: BaseVC {
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var index:Int? = 0
    var recipientID:String? = ""
    var messagesArray = [UserChatModel.Message]()
    private var player = AVPlayer()
    private var playerItem:AVPlayerItem!
    private var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ProductTableCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.setupUI()
    }
    private func setupUI(){
        let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
        let message = favoriteAll[self.recipientID ?? ""] ?? []
        if message.isEmpty{
            self.tableView.isHidden = true
            self.noDataImage.isHidden = false
            self.noDataLabel.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.noDataImage.isHidden = true
            self.noDataLabel.isHidden = true
            for item in message{
                       let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                       self.messagesArray.append(favoriteMessage!)
                   }
                   self.tableView.separatorStyle = .none
        }
       
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
    
}
extension FavoriteVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messagesArray.count == 0{
            
            return UITableViewCell()
        }
        let object = self.messagesArray[indexPath.row]
        
        if object.media == ""{
            if object.type == "right_text"{
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier) as? ChatSender_TableCell
                cell?.selectionStyle = .none
                cell?.messageTxtView.text = (object.text?.htmlAttributedString ?? "")!
//                 cell?.dateLabel.text = object.timeText?.htmlAttributedString ?? ""
//                cell?.messageTxtView.isEditable = false
                cell?.messageTxtView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
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
                
                
            }else if object.type == "left_text"{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiver_TableCell.identifier) as? ChatReceiver_TableCell
                
                cell?.messageTxtView.text = (object.text?.htmlAttributedString ?? "")! + "\n\n\(object.timeText?.htmlAttributedString ?? "")" ?? ""
//                cell?.messageTxtView.isEditable = false
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
            }else if object.type == "right_contact"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderContact_TableCell.identifier) as? ChatSenderContact_TableCell
                let data = object.text?.htmlAttributedString!.data(using: String.Encoding.utf8)
              //  let result = try! JSONDecoder().decode(ContactModel.self, from: data!)
              //  log.verbose("Result Model = \(result)")
                let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                log.verbose("dictionary = \(dic)")
                cell?.nameLabel.text = "\(dic?["key"] ?? "")"
                cell?.contactLabel.text  =  "\(dic?["value"] ?? "")"
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: "#a84849")
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
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverContact_TableCell.identifier) as? ChatReceiverContact_TableCell
                log.verbose("object.text?.htmlAttributedString? = \(object.text?.htmlAttributedString)")
                let newString = object.text?.htmlAttributedString!.replacingOccurrences(of: "\\\\", with: "")
                log.verbose("newString= \(newString)")
                let data = object.text?.htmlAttributedString?.data(using: String.Encoding.utf8)
                let result = try? JSONDecoder().decode(ContactModel.self, from: data!)
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
                cell?.fileImage.isHidden = false
                cell?.videoView.isHidden = true
                cell?.playBtn.isHidden = true
                let url = URL.init(string:object.media ?? "")
                cell?.fileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
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
                cell?.fileImage.isHidden = true
                cell?.videoView.isHidden = false
                cell?.playBtn.isHidden = false
                cell?.delegate = self
                cell?.index  = indexPath.row
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
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
                let url = URL.init(string:object.media ?? "")
                cell?.stickerImage.sd_setImage(with: url , placeholderImage:nil)
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
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
                cell?.delegate = self
                cell?.index = indexPath.row
                cell?.url = object.media ?? ""
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex: "#a84849")
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
            }else if object.type == "left_audio"{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverAudio_TableCell.identifier) as? ChatReceiverAudio_TableCell
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
                cell?.fileNameLabel.text = object.mediaFileName ?? ""
                cell?.timeLabel.text = object.timeText ?? ""
                cell?.backView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
           let copy = UIAlertAction(title: NSLocalizedString("Copy", comment: "Copy"), style: .default) { (action) in
               log.verbose("Copy")
               UIPasteboard.general.string = self.messagesArray[indexPath.row].text ?? ""
           }
           let messageInfo = UIAlertAction(title: NSLocalizedString("Message Info", comment: "Message Info"), style: .default) { (action) in
                      log.verbose("message Info")
                      let vc = R.storyboard.favorite.chatInfoVC()
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
                self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row], indexPath: indexPath.row)
               }
               
           }else{
               favoriteMessage = UIAlertAction(title: NSLocalizedString("Favorite", comment: "Favorite"), style: .default) { (action) in
                   log.verbose("favorite message = \(indexPath.row)")
                self.setFavorite(receipentID: self.recipientID ?? "", ID: self.messagesArray[indexPath.row].id ?? "", object: self.messagesArray[indexPath.row], indexPath: indexPath.row)
               }
               
               
           }
           let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
           
           alert.addAction(copy)
           alert.addAction(messageInfo)
           alert.addAction(deleteMessage)
           alert.addAction(forwardMessage)
           alert.addAction(favoriteMessage!)
           alert.addAction(cancel)
           
           self.present(alert, animated: true, completion: nil)
           //         let vc = R.storyboard.chat.showChatIntentsVC()
           //        let object = self.messagesArray[indexPath.row]
           //        if object.type == "right_image"{
           //            vc?.imageUrl = object.media ?? ""
           //        }else if object.type == "left_image"{
           //            vc?.imageUrl = object.media ?? ""
           //        }else if object.type == "right_video"{
           //            vc?.videoUrl = object.media ?? ""
           //        }else if object.type == "left_video"{
           //               vc?.videoUrl = object.media ?? ""
           //        }
           //        self.present(vc!, animated: true, completion: nil)
           //    }
       }
    private func setFavorite(receipentID:String,ID:String,object:UserChatModel.Message,indexPath:Int){
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
            self.messagesArray.remove(at: indexPath)
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
}
extension FavoriteVC:PlayVideoDelegate{
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
extension FavoriteVC:PlayAudioDelegate{
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
