
import UIKit
import WoWonderTimelineSDK
class NoInternetDialogVC: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func retryPressed(_ sender: Any) {
        if(Connectivity.isConnectedToNetwork()) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.makeToast(NSLocalizedString("Internet not connected, please check your internet connection.", comment: "Internet not connected, please check your internet connection."), duration: 2.0, position: .bottom)
        }
    }
}

