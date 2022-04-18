//
//  WeatherCell_UI.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 18/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class WeatherCell_UI: UITableViewCell {

    @IBOutlet weak var tempImageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(){
        tempImageView.image = UIImage(named: "weather template")
        tempImageView.contentMode = .scaleToFill
        tempImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
