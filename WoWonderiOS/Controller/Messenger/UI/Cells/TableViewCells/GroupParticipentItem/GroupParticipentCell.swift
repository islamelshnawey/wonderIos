//
//  GroupParticipentCell.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/15/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class GroupParticipentCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.text = ControlSettings.WoWonderText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
