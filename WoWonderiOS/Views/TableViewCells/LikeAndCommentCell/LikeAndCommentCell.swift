//
//  LikeAndCommentCell.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/10/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import AVFoundation

class LikeAndCommentCell: UITableViewCell,AddReactionDelegate{

    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    var vc: UIViewController?
    var post_id = ""
    var reaction = [String:Any]()
    var post_data = [String:Any]()
    
    let playRing = URL(fileURLWithPath: Bundle.main.path(forResource: "button", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.likeBtn.setTitle("\("       ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
        self.commentBtn.setTitle("\("     ")\(NSLocalizedString("Comment", comment: "Comment"))", for: .normal)
        
        let normalTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.NormalTapped(gesture:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.LongTapped(gesture:)))
        normalTapGesture.numberOfTapsRequired = 1
        longGesture.minimumPressDuration = 0.30
        self.likeBtn.addGestureRecognizer(normalTapGesture)
        self.likeBtn.addGestureRecognizer(longGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bind (data: [String:Any]){
        self.post_data = data
        if let reaction = data["reaction"] as? [String:Any]{
            self.reaction = reaction
        }
        
        if let reactions = self.reaction as? [String:Any]{
            if let isreact  = reactions["is_reacted"] as? Bool {
                if isreact == true{
                    if let type = reactions["type"] as? String{
                        if type == "6"{
                            self.likeBtn.setImage(UIImage(named: "angry"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
                            self.likeBtn.setTitleColor(.red, for: .normal)
                        }
                        else if type == "1"{
                            self.likeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                        }
                        else if type == "2"{
                            self.likeBtn.setImage(UIImage(named: "love"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
                            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
                        }
                        else if type == "4"{
                            self.likeBtn.setImage(UIImage(named: "wow"), for: .normal)
                            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
                        }
                        else if type == "5"{
                            self.likeBtn.setImage(UIImage(named: "sad"), for: .normal)
                            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
                        }
                        else if type == "3"{
                            self.likeBtn.setImage(UIImage(named: "haha"), for: .normal)
                            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
                            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
                        }
                    }
                }
                else{
                    self.likeBtn.setTitleColor(.lightGray, for: .normal)
                    self.likeBtn.setImage(UIImage(named:"like"), for: .normal)
                    self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                }
            }
        }
        
    }
    
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.vc?.present(vc, animated: true, completion: nil)
    }
    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.vc?.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
//            makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            self.audioPlayer.play()
            if let reactions = self.reaction as? [String:Any]{
                var totalCount = 0
                if let count = reactions["count"] as? Int{
                    totalCount = count
                }
            if let is_react = self.reaction["is_reacted"] as? Bool{
                if is_react == true{
                    self.reactions(index:0, reaction: "")
                    var localPostArray = self.reaction
                    localPostArray["is_reacted"] = false
                    localPostArray["type"]  = ""
                    localPostArray["count"] = totalCount - 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                    self.reaction = localPostArray
                    self.likeBtn.setImage(UIImage(named: "like"), for: .normal)
                    self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    self.likeBtn.setTitleColor(.lightGray, for: .normal)

                }
                else{
                    var localPostArray = self.reaction
                    localPostArray["is_reacted"] = true
                    localPostArray["type"]  = "Like"
                    localPostArray["count"] = totalCount + 1
                    localPostArray["Like"] = 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                    self.reaction = localPostArray
                    self.reactions(index: 0, reaction: "1")
                    self.likeBtn.setImage(UIImage(named: "like-2"), for: .normal)
                    self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
                    self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
                }
            }
            
            
        }
    }
    
    }
    
    @IBAction func Like(_ sender: Any) {
        
    }
    
    
    @IBAction func Comment(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentController
        if let postId = self.post_data["post_id"] as? String{
            vc.postId = postId
        }
        if let status = self.post_data["comments_status"] as? String{
            vc.commentStatus = status
        }
        if let reaction = self.post_data["reaction"] as? [String:Any]{
            if let count = reaction["count"] as? Int{
                vc.likes = count
            }
        }
        if let comments = self.post_data["get_post_comments"] as? [[String:Any]]{
            print(comments)
//            vc.comments = comments
        }
        if let counts = self.post_data["post_comments"] as? String{
            print(counts)
//            self.comment_count = counts
        }
//        self.selectedIndex = sender.tag
//        vc.deleagte = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.vc?.present(vc, animated: true, completion: nil)
    }
    
    
    private func reactions(index :Int, reaction: String) {
        performUIUpdatesOnMain {
//            var postID = self.
//            if let postId = self.postArray[index]["post_id"] as? String{
//                postID = postId
//            }
            AddReactionManager.sharedInstance.addReaction(postId: self.post_id, reaction: reaction) { (success, authError, error) in
                if success != nil{
                    print(success?.action)
                }
                else if authError != nil{
                    print(authError?.errors.errorText)
                }
                else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    
    func addReaction(reation: String) {
        self.audioPlayer.play()
        self.reactions(index: 0, reaction: reation)
        var localPostArray = self.reaction
        var totalCount = 0
        if let reactions = self.reaction as? [String:Any]{
            if let is_react = reactions["is_reacted"] as? Bool{
                if !is_react {
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                    localPostArray["count"] = totalCount + 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                }
                else{
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                }
            }
        }
        localPostArray["is_reacted"] = true
        localPostArray["type"]  = reation
        
        if reation == "1"{
            localPostArray["Like"] = 1
            localPostArray["1"] = 1
            self.reaction = localPostArray
            self.likeBtn.setImage(UIImage(named: "like-2"), for: .normal)
            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            localPostArray["Love"] = 1
            localPostArray["2"] = 1
            self.reaction = localPostArray
            self.likeBtn.setImage(UIImage(named: "love"), for: .normal)
            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
        }
        else if reation == "3"{
            localPostArray["HaHa"] = 1
            localPostArray["3"] = 1
            self.reaction["reaction"] = localPostArray
            self.likeBtn.setImage(UIImage(named: "haha"), for: .normal)
            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
        }
        else if reation == "4"{
            localPostArray["Wow"] = 1
            localPostArray["4"] = 1
            self.reaction = localPostArray
            self.likeBtn.setImage(UIImage(named: "wow"), for: .normal)
            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
        }
        else if reation == "5"{
            localPostArray["Sad"] = 1
            localPostArray["5"] = 1
            self.reaction = localPostArray
            self.likeBtn.setImage(UIImage(named: "sad"), for: .normal)
            self.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
        }
        else {
            localPostArray["Angry"] = 1
            localPostArray["6"] = 1
            self.reaction = localPostArray
            self.likeBtn.setImage(UIImage(named: "angry"), for: .normal)
self.likeBtn.setTitle("\("      ")\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)

            self.likeBtn.setTitleColor(.red, for: .normal)
        }
        
    }
    
    
    
}
