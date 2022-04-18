//
//  SortFilterCell.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/12/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SortFilterCell: UITableViewCell {

    @IBOutlet var followLbl: UILabel!
    @IBOutlet var sortLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followLbl.text = NSLocalizedString("All", comment: "All")
        self.sortLbl.text = NSLocalizedString("Sort", comment: "Sort")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
