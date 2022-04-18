//
//  TrendingHeaderCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 17/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class TrendingHeaderCells: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var seeAllButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
