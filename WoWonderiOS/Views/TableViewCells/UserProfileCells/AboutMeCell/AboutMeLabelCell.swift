//
//  AboutMeLabelCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 12/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class AboutMeLabelCell: UITableViewCell {

    @IBOutlet weak var aboutMeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        aboutMeLabel.numberOfLines = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
