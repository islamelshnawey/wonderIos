//
//  ProfileHeaderCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 11/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

    var vc: UserProfileVC?
    var userData:[String:Any]?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userprofileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func bind(userData: [String:Any]){
        self.userData = userData
        if let cover = userData["cover"] as? String{
            let url = URL(string: cover)
            coverImageView.kf.setImage(with: url)
        }
        if let image = userData["avatar"] as? String{
            let url = URL(string: image)
            userprofileImageView.kf.setImage(with: url)
        }
        if let name = userData["name"] as? String{
            nameLabel.text = name
        }
        if let username = userData["username"] as? String{
            usernameLabel.text = "@\(username)"
        }
        
        if let isFollwoing = userData["is_following"] as? Int{
            if isFollwoing == 0{
                followButton.setTitle("Follow", for: .normal)
            }
            else{
                followButton.setTitle("Following", for: .normal)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreClicked(_ sender: Any) {
        self.vc?.goToMore()
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        //..
    }
    
    @IBAction func followClicked(_ sender: Any) {
        var user_id: String? = nil
        if let userId = userData?["user_id"] as? String{
            user_id = userId
        }
        if let is_following = userData?["is_following"] as? Int{
            if is_following == 0{
                self.followButton.setTitle("Following", for: .normal)
                self.vc?.sendRequest(user_id: user_id ?? "")
                self.userData?["is_following"] = 1
            }
            else {
                self.followButton.setTitle("Follow", for: .normal)
                self.vc?.sendRequest(user_id: user_id ?? "")
                self.userData?["is_following"] = 0
            }
        }
    }
    

}
