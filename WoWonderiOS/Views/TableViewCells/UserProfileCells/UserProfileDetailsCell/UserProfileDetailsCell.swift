//
//  UserProfileDetailsCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 11/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class UserProfileDetailsCell: UITableViewCell {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
