

import UIKit

class ProgressDialog {
    init() {
        SKActivityIndicator.spinnerStyle(.spinningCircle)
    }
    
    func show(){
        SKActivityIndicator.show()
    }
    
    func dismiss(){
        SKActivityIndicator.dismiss()
    }
}
