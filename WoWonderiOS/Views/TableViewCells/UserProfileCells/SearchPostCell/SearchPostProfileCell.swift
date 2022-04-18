//
//  SearchPostProfileCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 13/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SearchPostProfileCell: UITableViewCell {
    
    var vc:UserProfileVC?
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupUI()
    }
    
    func setupUI(){
        searchView.layer.cornerRadius = 8
        searchTextField.returnKeyType = .search
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
