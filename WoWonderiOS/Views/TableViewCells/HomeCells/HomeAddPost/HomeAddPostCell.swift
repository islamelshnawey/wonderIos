//
//  HomeAddPostCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 09/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class HomeAddPostCell: UITableViewCell {

    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var userprofileImage: UIImageView!
    var vc:HomeVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func liveClicked(_ sender: Any) {
        self.vc?.createLive()
    }
    
    @IBAction func tagClicked(_ sender: Any) {
        self.vc?.goToAddPost()
    }
    
    @IBAction func galleryButton(_ sender: Any) {
        self.vc?.goToAddPost()
    }
}
