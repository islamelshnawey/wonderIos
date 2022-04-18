//
//  LiveCommentCell.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/23/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class LiveCommentCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet var proimage: Roundimage!
    @IBOutlet var userName: UILabel!
    @IBOutlet var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
