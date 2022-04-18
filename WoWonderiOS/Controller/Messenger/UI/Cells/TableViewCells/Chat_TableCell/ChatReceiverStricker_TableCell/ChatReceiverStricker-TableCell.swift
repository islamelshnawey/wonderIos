

import UIKit

class ChatReceiverStricker_TableCell: UITableViewCell {
    @IBOutlet weak var stickerImage: UIImageView!
    
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
