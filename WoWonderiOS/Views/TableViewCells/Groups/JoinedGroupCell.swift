

import WoWonderTimelineSDK
import UIKit

class JoinedGroupCell: UITableViewCell {
    
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupIcon: Roundimage!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var joinedBtn: UIButton!
    
    /// No Group outlet
    @IBOutlet weak var noGroupview: UIView!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var notextLbl: UILabel!
    @IBOutlet weak var searchBtn: RoundButton!
    
    var isJoined = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.joinedBtn.setTitle(NSLocalizedString("JOINED", comment: "JOINED"), for: .normal)
        self.joinedBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        
        self.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noLabel.text = NSLocalizedString("No Joined Group Yet", comment: "No Joined Group Yet")
        self.notextLbl.text = NSLocalizedString("Join or start your Own Group", comment: "Join or start your Own Group")
        self.searchBtn.setTitle(NSLocalizedString("Search", comment: "Search"), for: .normal)
        self.searchBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
