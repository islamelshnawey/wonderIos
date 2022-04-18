//
//  AddParticipantCell.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/15/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class AddParticipantCell: UITableViewCell {

    @IBOutlet weak var addParticipantLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addParticipantLabel.text = NSLocalizedString("Add Participants", comment: "Add Participants")
        self.contactLabel.text = NSLocalizedString("Select from your contact list", comment: "Select from your contact list")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
