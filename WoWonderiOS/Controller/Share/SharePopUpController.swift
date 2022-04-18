
import UIKit
import WoWonderTimelineSDK

class SharePopUpController: UIViewController {

    var delegate : SharePostDelegate!
    
    @IBOutlet var shareLbl: UILabel!
    @IBOutlet var shareTimeLbl: UILabel!
    @IBOutlet var noLbl: UIButton!
    @IBOutlet var yesLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.shareLbl.text = NSLocalizedString("Share", comment: "Share")
        self.shareTimeLbl.text = NSLocalizedString("Share to my Timeline", comment: "Share to my Timeline")
        self.noLbl.setTitle(NSLocalizedString("NO", comment: "NO"), for: .normal)
        self.yesLbl.setTitle(NSLocalizedString("YES", comment: "YES"), for: .normal)
        self.noLbl.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.yesLbl.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
    }
    
    @IBAction func Yes(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate.sharePost()
        }
        
    }
    
    @IBAction func No(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
