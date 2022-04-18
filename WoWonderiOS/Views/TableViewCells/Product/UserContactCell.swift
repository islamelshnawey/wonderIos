

import UIKit
import WoWonderTimelineSDK


class UserContactCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: Roundimage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var contatBtn: RoundButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contatBtn.setTitle(NSLocalizedString("Contact", comment: "Contact"), for: .normal)
        self.contatBtn.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.contatBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
    }


    // Configure the view for the selected state
    }


