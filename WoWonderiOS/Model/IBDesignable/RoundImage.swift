//
//  RoundImage.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/14/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
@IBDesignable
class RoundImage: UIImageView {

    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = .white {
        didSet{
            layer.borderColor = borderColor.cgColor
            
        }
        
    }

}
