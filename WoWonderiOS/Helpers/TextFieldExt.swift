
import UIKit

extension UITextField {
    
    func whitePlaceHolder(text:String){
        self.attributedPlaceholder = NSAttributedString(string: text,
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
