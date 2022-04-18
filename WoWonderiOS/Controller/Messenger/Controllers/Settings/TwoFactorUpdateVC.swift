

import UIKit

class TwoFactorUpdateVC: UIViewController {

    var delegate:TwoFactorAuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func disablePressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.getTwoFactorUpdateString(type: "off")
        }
    }
    @IBAction func enablePressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.getTwoFactorUpdateString(type: "on")
        }
    }
}
