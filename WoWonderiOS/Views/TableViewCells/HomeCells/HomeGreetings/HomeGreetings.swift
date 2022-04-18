//
//  HomeGreetings.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 09/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class HomeGreetings: UITableViewCell {

    @IBOutlet weak var greetingDetailLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userprofileImageView: UIImageView!
    var vc:HomeVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
