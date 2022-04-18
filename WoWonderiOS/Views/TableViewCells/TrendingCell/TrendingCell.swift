//
//  TrendingCell.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/11/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class TrendingCell: UITableViewCell {
    
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var totalPostsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
