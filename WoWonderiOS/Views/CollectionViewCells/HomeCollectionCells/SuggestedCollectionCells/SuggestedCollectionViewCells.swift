//
//  SuggestedCollectionViewCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 14/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SuggestedCollectionViewCells: UICollectionViewCell {
    
    var isjoin:Bool?
    
    @IBOutlet weak var userprofileImageView: UIImageView!
    @IBOutlet weak var profileLeading: NSLayoutConstraint!
    @IBOutlet weak var profileWidth: NSLayoutConstraint!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var backView: UIView!
    var vc:HomeVC?

    override func awakeFromNib() {
        super.awakeFromNib()
        groupImageView.clipsToBounds = true
        groupImageView.layer.cornerRadius = 8
        groupImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        textView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    @IBAction func joinGroupClicked(_ sender: Any) {
       
        if self.isjoin == true{
            if self.joinGroupButton.currentTitle == "Follow"{
                self.joinGroupButton.setTitle("Requested", for: .normal)
            }else{
                self.joinGroupButton.setTitle("Follow", for: .normal)
            }
        }else{
            if self.joinGroupButton.currentTitle == "Join Group"{
                self.joinGroupButton.setTitle("Requested", for: .normal)
            }else{
                self.joinGroupButton.setTitle("Join Group", for: .normal)
            }
        }
        
        
        
    }
}
