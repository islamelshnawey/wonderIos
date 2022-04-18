//
//  FriendRequestCell.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/17/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var image1: RoundImage!
    @IBOutlet weak var image2: RoundImage!
    @IBOutlet weak var image3: RoundImage!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var viewallLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followLabel.text = NSLocalizedString("Follow Request", comment: "Follow Request")
        self.viewallLabel.text = NSLocalizedString("View all Follow Request", comment: "View all Follow Request")
        self.bgView.backgroundColor = .mainColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
