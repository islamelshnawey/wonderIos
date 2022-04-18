//
//  GroupChatInfoVC.swift
//  WoWonder
//
//  Created by Abdul Moid on 08/01/2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit
import Async
import WoWonderTimelineSDK
import AVFoundation
import AVKit

class GroupChatInfoVC: BaseVC
{
    @IBOutlet weak var tableView: UITableView!
    var index:Int? = 0
    var recipientID:String? = ""
    var object:GroupChatModel.Message!
    var player = AVPlayer()
    private var playerItem:AVPlayerItem!
    private var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
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
        tableView.register( R.nib.chatInfoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.chatInfoTableItem.identifier)
        
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
extension GroupChatInfoVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            if object.media == ""{
                if object.type == "right_text"{
                    
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSender_TableCell.identifier) as? ChatSender_TableCell
                    cell?.selectionStyle = .none
                    cell?.messageTxtView.text = (object.text?.htmlAttributedString ?? "")!
                    //                     cell?.dateLabel.text = object.timeText?.htmlAttributedString ?? ""
                    //                    cell?.messageTxtView.isEditable = false
                    cell?.messageTxtView.backgroundColor = UIColor.hexStringToUIColor(hex:  "#a84849")
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                    //                    cell?.messageTxtView.isEditable = false
                    let favoriteAll =  UserDefaults.standard.getFavorite(Key: Local.FAVORITE.favorite)
                    let message = favoriteAll[self.recipientID ?? ""] ?? []
                    var status:Bool? = false
                    for item in message{
                        let favoriteMessage = try? PropertyListDecoder().decode(UserChatModel.Message.self ,from: item)
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                    let result = try! JSONDecoder().decode(ContactModel.self, from: data!)
                    log.verbose("Result Model = \(result)")
                    let dic = convertToDictionary(text: (object.text?.htmlAttributedString!)!)
                    log.verbose("dictionary = \(dic)")
                    cell?.nameLabel.text = "\(dic!["key"] ?? "")"
                    cell?.contactLabel.text  =  "\(dic!["value"] ?? "")"
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
                        if object.id ?? "" == favoriteMessage?.id ?? ""{
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
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatInfoTableItem.identifier) as? ChatInfoTableItem
            
            if object.seen == "0"{
                cell!.readLabel.text = "---"
            }else{
                let value = Double(object.seen!)
                cell!.readLabel.text = convertDate(dateValue: value!)
            }
            if object.time == "0"{
                cell!.deliverLabel.text = "---"
            }else{
                let value = Double(object.time!)
                cell!.deliverLabel.text = convertDate(dateValue: value!)
            }
            return cell!
            
        default:
            return UITableViewCell()
        }
        
        
        
        
    }
    func convertDate(dateValue: Double) -> String {
        let date = Date(timeIntervalSince1970: dateValue)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 400.0
            
        default:
            return UITableView.automaticDimension
            
        }
        return UITableView.automaticDimension
    }
}
extension GroupChatInfoVC:PlayVideoDelegate{
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
extension GroupChatInfoVC:PlayAudioDelegate{
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

