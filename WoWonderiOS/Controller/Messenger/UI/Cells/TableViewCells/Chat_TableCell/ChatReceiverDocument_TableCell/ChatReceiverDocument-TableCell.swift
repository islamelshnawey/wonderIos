

import UIKit

class ChatReceiverDocument_TableCell: UITableViewCell {
    @IBOutlet weak var starBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mBLabel: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
