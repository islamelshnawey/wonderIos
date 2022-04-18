
import UIKit
import WoWonderTimelineSDK

class ShareController: UIViewController {
    
    var delegate :SharePostDelegate!
    

    @IBOutlet var timeLineBtn: UIButton!
    @IBOutlet var shareGroupBtn: UIButton!
    @IBOutlet var moreOptionBtn: UIButton!
    @IBOutlet var sahrePageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeLineBtn.setTitle("   \(NSLocalizedString("Share to my Timeline", comment: "Share to my Timeline"))", for: .normal)
        self.shareGroupBtn.setTitle("   \(NSLocalizedString("Share to a Group", comment: "Share to a Group"))", for: .normal)
        self.moreOptionBtn.setTitle("   \(NSLocalizedString("More Options", comment: "More Options"))", for: .normal)
        self.sahrePageBtn.setTitle("   \(NSLocalizedString("Share to a Page", comment: "Share to a Page"))", for: .normal)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func SharePost(_ sender: UIButton) {
        if sender.tag == 0{
            print("Share to Timeline")
            self.dismiss(animated: true) {
                self.delegate.sharePostTo(type: "timeline")
            }
        }
        else if sender.tag == 1{
            print("Share to Group")
            self.dismiss(animated: true) {
                self.delegate.sharePostTo(type: "group")
            }
            
        }
        else if sender.tag == 2{
            print("Activity")
            self.dismiss(animated: true) {
               self.delegate.sharePostLink()
            }
        }
        else {
            self.dismiss(animated: true) {
              self.delegate.sharePostTo(type: "page")
            }
            self.delegate.sharePostTo(type: "page")
            print("Share to Page")

        }
        
    }
    
}
