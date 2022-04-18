//
//  TrendingBlogsCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 19/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class TrendingBlogsCells: UITableViewCell {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var topAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var reactionImageView: UIImageView!
    @IBOutlet weak var blogDescpLabel: UILabel!
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userTimeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var blogImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupUI()
    }
    
    func setupUI(){
        
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 5
        backView.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
//        blogImageView.kf.setImage(with: image)
        blogImageView.clipsToBounds = true
        blogImageView.layer.cornerRadius = 5
        blogImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
