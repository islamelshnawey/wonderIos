//
//  UserProfileDataCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 11/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class UserProfileDataCell: UITableViewCell {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func bind(userData: [String:Any]){
        if let details = userData["details"] as? [String:Any]{
            if let followerCount = details["followers_count"] as? String{
                followersLabel.text = followerCount
            }
            if let followingCount = details["following_count"] as? String{
                followingLabel.text = followingCount
            }
            if let likesCount = details["likes_count"] as? String{
                likesLabel.text = likesCount
            }
        }
        if let points = userData["points"] as? String{
            pointsLabel.text = points
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
