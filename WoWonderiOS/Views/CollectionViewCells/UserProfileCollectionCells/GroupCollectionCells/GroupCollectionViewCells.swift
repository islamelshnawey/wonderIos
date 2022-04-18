//
//  GroupCollectionViewCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 12/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class GroupCollectionViewCells: UICollectionViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(image:URL?, name:String){
        groupImageView.kf.setImage(with: image)
        groupImageView.clipsToBounds = true
        groupImageView.layer.cornerRadius = 2.5
        groupImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        groupNameLabel.text = name
        groupNameLabel.layer.borderWidth = 1
        groupNameLabel.layer.cornerRadius = 2.5
        groupNameLabel.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        groupNameLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
