//
//  TempMsgCollectionViewCell.swift
//  WoWonder
//
//  Created by Abdul Moid on 16/01/2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

class TempMsgCollectionViewCell: UICollectionViewCell {
    
    let msgLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(msgLabel)
        
        
        msgLabel.textAlignment = .center
        msgLabel.textColor = .darkGray
        
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        msgLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        msgLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        msgLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
