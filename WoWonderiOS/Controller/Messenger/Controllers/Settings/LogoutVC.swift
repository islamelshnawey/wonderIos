

import UIKit
import WoWonderTimelineSDK
class LogoutVC: BaseVC {
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        self.warningLabel.text = NSLocalizedString("Warning !", comment: "")
         self.downTextLabel.text = NSLocalizedString("Are you sure you want to logout?", comment: "")
        self.cancelBtn.setTitle("CANCEL", for: .normal)
        self.okBtn.setTitle("OK", for: .normal)
    }
    @IBAction func okPressed(_ sender: Any) {
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func update() {
        UserDefaults.standard.clearUserDefaults()
    //    let vc = R.storyboard.main.main()
    //    appDelegate.window?.rootViewController = vc
     //   self.dismiss(animated: true, completion: nil)
        
    }
}
