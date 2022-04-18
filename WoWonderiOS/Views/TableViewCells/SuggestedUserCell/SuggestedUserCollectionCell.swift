//
//  SuggestedUserCollectionCell.swift
//  WoWonderiOS
//
//  Created by sinpanda on 3/2/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SuggestedUserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var followBtn: RoundButton!
    
    var data = [String:Any]()
    var userId:String? = ""
    
    override func awakeFromNib() {
        self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
        self.followBtn.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
    }
    
    @IBAction func followPressed(_ sender: Any) {
        self.follow_unfollowRequest(userId: self.userId ?? "")
    }
    
    func bind(object:[String:Any]){
        self.data = object
        if (object["first_name"] as? String)! + (object["last_name"] as? String)! == "" {
            self.userNameLabel.text = "No Name"
        }
        else {
            self.userNameLabel.text = (object["first_name"] as? String)! + (object["last_name"] as? String)!
        }
        var imageString = object["avatar"] as? String
        let url = URL(string: imageString ?? "")
        self.profileImage.kf.indicatorType = .activity
        self.profileImage.kf.setImage(with: url)
        self.userId = object["user_id"] as? String
        
//        if let last_time = object["lastseen"] as? String{
//            let epocTime = TimeInterval(Int(last_time) ?? 1601815559)
//            let myDate =  Date(timeIntervalSince1970: epocTime)
//            let formate = DateFormatter()
//            formate.dateFormat = "yyyy-MM-dd"
//            ////
//            self.timeLabel.text = myDate.timeAgoDisplay()
////            let dat = formate.string(from: myDate as Date)
////            print("Date",dat)
////            print("Converted Time \(myDate)")
////            self.timeLabel.text = "\(dat)"
//        }
        self.timeLabel.text = "@" + (object["username"] as! String)
        
        if let isFollowing = object["is_following"] as? String{
            if isFollowing == "no"{
                if (AppInstance.instance.connectivity_setting == "1"){
                    self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
                }
                else{
                 self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
                }
                self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                 self.followBtn.backgroundColor = .white
            }
            else if (isFollowing == "yes"){
               if (AppInstance.instance.connectivity_setting == "1"){
                     self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                    self.followBtn.backgroundColor = .white
                }
               else{
                   self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                       self.followBtn.setTitleColor(.white, for: .normal)
                        self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//                            UIColor.hexStringToUIColor(hex: "#984243")
                }
            }
                
            else {
                if (AppInstance.instance.connectivity_setting == "0"){
                     self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                }
                else{
                 self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
            }
         self.followBtn.setTitleColor(.white, for: .normal)
         self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//            UIColor.hexStringToUIColor(hex: "#984243")
        }
        }
        
        
    }
    
    private func follow_unfollowRequest(userId : String){
       performUIUpdatesOnMain {
            Follow_RequestManager.sharedInstance.sendFollowRequest(userId: userId) { (success, authError, error) in
                if success != nil {
                    if success?.follow_status ?? "" == "followed"{
                        if (AppInstance.instance.connectivity_setting == "0"){
                            self.data["is_following"] = "yes"
                            self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                            self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//                                    UIColor.hexStringToUIColor(hex: "#984243")
                            self.followBtn.setTitleColor(UIColor.white, for: .normal)

                        }
                        else{
                            if (self.data["is_following"] as? String == "no"){
                                self.followBtn.backgroundColor = UIColor.white
                                self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                                self.data["is_following"] = "yes"
                                self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                            }
                            else{
                                self.data["is_following"] = "yes"
                                self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
                                self.followBtn.setTitleColor(UIColor.white, for: .normal)
                                 self.followBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//                                        UIColor.hexStringToUIColor(hex: "#984243")

                            }
                        }

                        
                    }
                    else{
                        if (AppInstance.instance.connectivity_setting == "0"){
                             self.data["is_following"] = 0
                            self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
                            self.followBtn.backgroundColor = .white
                            self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                            
                        }
                        else{
                            self.data["is_following"] = 0
                            self.followBtn.setTitle(NSLocalizedString("Follow", comment: "Follow"), for: .normal)
                            self.followBtn.backgroundColor = .white
                            self.followBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
                        }
                    }
                }
                   else if authError != nil {
                   }
                   else if error != nil {
                   }
                   
               }
           }
           
       }
}
