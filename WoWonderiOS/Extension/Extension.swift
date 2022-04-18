
import Foundation
import UIKit

//enum UserDefaultsKeys : String {
//    case isLoggedIn
//    case userID
//}
extension UserDefaults{
    //MARK: Check Login
//    func setLoggedIn(value: Bool) {
//        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//        //synchronize()
//    }

//    func isLoggedIn()-> Bool {
//        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//    }

    //MARK: Save User Data
//    func setUserSession(value: [String:Any], ForKey:String){
//        set(value, forKey: ForKey)
//        //synchronize()
//    }
//    func getUserSessions(Key:String) -> [String:Any]{
//        return (object(forKey: Key) as? [String:Any]) ?? [:]
//    }

    func setGetSettings(value: [String:String], ForKey:String){
        set(value, forKey: ForKey)
        //synchronize()
    }

    func getGetSettings(Key:String) ->  [String:String]{
        return ((object(forKey: Key) as? [String:String]) ?? [:])!
    }
//    func setPassword(value: String, ForKey:String){
//        set(value, forKey: ForKey)
//        //synchronize()
//    }

//    func getPassword(Key:String) ->  String{
//        return object(forKey: Key)  as?  String ?? ""
//    }
    func setChatColorHex(value: String, ForKey:String){
        set(value, forKey: ForKey)
        //synchronize()
    }

    func getChatColorHex(Key:String) ->  String{
        return object(forKey: Key)  as?  String ?? ""
    }
    func setConversationTone(value: Bool, ForKey:String){
        set(value, forKey: ForKey)
        //synchronize()
    }

    func getConversationTone(Key:String) ->  Bool{
        return object(forKey: Key)  as?  Bool ?? false
    }

    func setCallLogs(value: [Data], ForKey:String){
        set(value, forKey: ForKey)
    }

    func getCallsLogs(Key:String) ->  [Data]{
        return object(forKey: Key)  as?  [Data] ?? []
    }

    func setNotification(value: Bool, ForKey:String){
        set(value, forKey: ForKey)
    }

    func getNotification(Key:String) ->  Bool{
        return object(forKey: Key)  as?  Bool ?? true
    }

    func setLanguage(value: String, ForKey:String){
        set(value, forKey: ForKey)
        synchronize()
    }
    func getLanguage(Key:String) ->  String{

        return ((object(forKey: Key) as? String) ?? "")!

    }
//    func setDeviceId(value: String, ForKey:String){
//        set(value, forKey: ForKey)
//        synchronize()
//    }
//    func getDeviceId(Key:String) ->  String{
//
//        return ((object(forKey: Key) as? String) ?? "")!
//
//    }
//    func setDarkMode(value: Bool, ForKey:String){
//        set(value, forKey: ForKey)
//        synchronize()
//
//    }
//    func getDarkMode(Key:String) ->  Bool{
//
//        return ((object(forKey: Key) as? Bool) ?? false)!
//
//    }

    func setFavorite(value: [String:[Data]], ForKey:String){
               set(value, forKey: ForKey)
               synchronize()
           }
           func getFavorite(Key:String) ->  [String:[Data]]{
            return ((object(forKey: Key) as? [String:[Data]]) ?? [:])
           }
//    func setNotificationStatus(value: Bool, ForKey:String){
//        set(value, forKey: ForKey)
//        synchronize()
//    }
//    func getNotificationStatus(Key:String) ->  Bool{
//        return ((object(forKey: Key) as? Bool) ?? false)!
//    }
    func setCOntinueAs(value:[String:String], ForKey:String){
        set(value, forKey: ForKey)
        synchronize()
    }
    func getContinueAs(Key:String) ->   [String:String]{
        return ((object(forKey: Key) as?  [String:String]) ??  [:])!
    }

//    func clearUserDefaults(){
//        removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//    }
//    func removeValuefromUserdefault(Key:String){
//        removeObject(forKey: Key)
//    }


}
extension String  {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
extension String {
    /// Converts HTML string to a `NSAttributedString`
    
    var htmlAttributedString: String? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}
extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
//    var mimeType: String {
//        var c: UInt8 = 0
//        copyBytes(to: &c, count: 1)
//        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
//    }
}
extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

//extension UITextView :UITextViewDelegate
//{
//
//    /// Resize the placeholder when the UITextView bounds change
//    override open var bounds: CGRect {
//        didSet {
//            self.resizePlaceholder()
//        }
//    }
//
//    /// The UITextView placeholder text
//    public var placeholder: String? {
//        get {
//            var placeholderText: String?
//
//            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//                placeholderText = placeholderLabel.text
//            }
//
//            return placeholderText
//        }
//        set {
//            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//                placeholderLabel.text = newValue
//                placeholderLabel.sizeToFit()
//            } else {
//                self.addPlaceholder(newValue!)
//            }
//        }
//    }
//
//    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
//    ///
//    /// - Parameter textView: The UITextView that got updated
//    public func textViewDidChange(_ textView: UITextView) {
//        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//            placeholderLabel.isHidden = self.text.characters.count > 0
//        }
//    }
//
//    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
//    private func resizePlaceholder() {
//        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//            let labelX = self.textContainer.lineFragmentPadding
//            let labelY = self.textContainerInset.top - 2
//            let labelWidth = self.frame.width - (labelX * 2)
//            let labelHeight = placeholderLabel.frame.height
//
//            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
//        }
//    }
//
//    /// Adds a placeholder UILabel to this UITextView
//    private func addPlaceholder(_ placeholderText: String) {
//        let placeholderLabel = UILabel()
//
//        placeholderLabel.text = placeholderText
//        placeholderLabel.sizeToFit()
//
//        placeholderLabel.font = self.font
//        placeholderLabel.textColor = UIColor.lightGray
//        placeholderLabel.tag = 100
//
//        placeholderLabel.isHidden = self.text.characters.count > 0
//
//        self.addSubview(placeholderLabel)
//        self.resizePlaceholder()
//        self.delegate = self
//    }
//}
extension UITextView {
    
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }
    
  //  @IBInspectable
//    var placeholder: String {
//        get {
//            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
//        }
//        set {
//            let placeholderLabel = self.placeholderLabel
//            placeholderLabel.text = newValue
//            placeholderLabel.numberOfLines = 0
//            let width = frame.width - textContainer.lineFragmentPadding * 2
//            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
//            placeholderLabel.frame.size.height = size.height
//            placeholderLabel.frame.size.width = width
//            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
//
//            textStorage.delegate = self
//        }
//    }
    
}

//extension UITextView: NSTextStorageDelegate {
//    
//    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        if editedMask.contains(.editedCharacters) {
//            placeholderLabel.isHidden = !text.isEmpty
//        }
//    }
//    
//}
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: date)
    }
}

extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
