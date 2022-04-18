//
//  OtherCell.swift
//  WoWonderiOS
//
//  Created by sinpanda on 2/28/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class OtherCell: UITableViewCell {

    @IBOutlet weak var moringLabel: UILabel!
    @IBOutlet weak var morningDetailsLabel: UILabel!
    @IBOutlet weak var morningImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
