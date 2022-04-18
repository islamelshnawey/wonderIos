

import UIKit

class GroupRequest_TableCell: UITableViewCell {
    
    

    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var iniviteFriendLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.requestLabel.text = NSLocalizedString("Group Request", comment: "Group Request")
        self.iniviteFriendLabel.text = NSLocalizedString("Find all invite request", comment: "Find all invite request")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
