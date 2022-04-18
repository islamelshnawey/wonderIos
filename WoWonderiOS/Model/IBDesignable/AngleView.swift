//
//  AngleView.swift
//  WoWonder
//
//  Created by Ubaid Javaid on 7/15/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
@IBDesignable
class AngleView: UIView {

//    @IBInspectable public var fillColor: UIColor = .blue { didSet { setNeedsLayout() } }

    @IBInspectable var color: UIColor = .red
    @IBInspectable var firstPointX: CGFloat = 0
    @IBInspectable var firstPointY: CGFloat = 0
    @IBInspectable var secondPointX: CGFloat = 0.5
    @IBInspectable var secondPointY: CGFloat = 1
    @IBInspectable var thirdPointX: CGFloat = 0
    @IBInspectable var thirdPointY: CGFloat = 1
       
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.secondPointX * rect.width, y: self.secondPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.thirdPointX * rect.width, y: self.thirdPointY * rect.height))
        aPath.close()
        self.color.set()
        self.backgroundColor = .clear
        aPath.fill()
    }
    
}
