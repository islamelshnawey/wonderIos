//
//  ProductTableCell.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/19/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ProductTableCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundImage!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
