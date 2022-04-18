//
//  RoundView.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/14/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
@IBDesignable
class RoundView: UIView {
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
       
       @IBInspectable var shadow_Radius: CGFloat{
           get {
               return layer.shadowRadius
           }
           set {
               layer.shadowRadius = newValue
               layer.masksToBounds = false
           }
       }
       @IBInspectable
       var shadowOpacity: Float {
           get {
               return layer.shadowOpacity
           }
           set {
               layer.shadowOpacity = newValue
           }
       }
       
       @IBInspectable
       var shadowOffset: CGSize {
           get {
               return layer.shadowOffset
           }
           set {
               layer.shadowOffset = newValue
           }
       }
       
       @IBInspectable
       var shadowColor: UIColor? {
           get {
               if let color = layer.shadowColor {
                   return UIColor(cgColor: color)
               }
               return nil
           }
           set {
               if let color = newValue {
                   layer.shadowColor = color.cgColor
               } else {
                   layer.shadowColor = nil
               }
           }
       }

}
