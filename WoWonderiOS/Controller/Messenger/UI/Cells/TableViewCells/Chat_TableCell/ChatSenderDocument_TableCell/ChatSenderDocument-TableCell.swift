
import UIKit

class ChatSenderDocument_TableCell: UITableViewCell {

    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mBLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
