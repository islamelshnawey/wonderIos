
import UIKit

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    static func makeScreenshot(view:UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { (context) in
            view.layer.render(in: context.cgContext)
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func isRoundedRect(cornerRadius : CGFloat,hasBorderColor : UIColor?){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        if hasBorderColor != nil {
            self.layer.borderWidth = 1
            self.layer.borderColor = hasBorderColor!.cgColor
        }
    }
    
    func addShadow(){
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
    }
    
    func applyGradient(colours: [UIColor], start: CGPoint?, end: CGPoint?,borderColor:UIColor,cornerRadius:Float? = nil) -> Void {
        
        var gradient: CAGradientLayer!
        
        gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = start!
        gradient.endPoint = end!
       
        gradient.borderColor = borderColor.cgColor
        gradient.borderWidth = 1
        
        if cornerRadius != nil {
             gradient.cornerRadius = 10
        }
        
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(colours: [UIColor], start: CGPoint?, end: CGPoint?) -> Void {
        
        var gradient: CAGradientLayer!
        
        gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = start!
        gradient.endPoint = end!
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer{
            topLayer.removeFromSuperlayer()
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }

    func roundedRect(cornerRadius : CGFloat,borderColor : UIColor){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    func isRoundedRect(cornerRadius : CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                     cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    
    
    func isCircular(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func isCircular(borderColor : UIColor){
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
  
//    enum ViewSide {
//        case Left, Right, Top, Bottom
//    }
//    
//    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
//        
//        let border = CALayer()
//        border.backgroundColor = color
//        
//        switch side {
//        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
//        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
//        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
//        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
//        }
//        
//        layer.addSublayer(border)
//    }
//    
//
//    
//    var cornerRadiusV: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//    
//    @IBInspectable var borderWidthV: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//    
//    @IBInspectable var borderColorV: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//    
//    @IBInspectable var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
