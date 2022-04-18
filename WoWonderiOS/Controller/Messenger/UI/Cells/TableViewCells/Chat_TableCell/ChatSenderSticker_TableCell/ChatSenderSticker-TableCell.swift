
import UIKit
import GoogleMaps

class ChatSenderSticker_TableCell: UITableViewCell {

    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stickerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
