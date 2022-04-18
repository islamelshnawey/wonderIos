

import UIKit

class ChatReceiver_TableCell: UITableViewCell {
    @IBOutlet weak var messageTxtView: UITextView!

    @IBOutlet weak var starBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageTxtView.layer.cornerRadius = 10
        self.messageTxtView.layer.borderColor = UIColor.clear.cgColor
        self.messageTxtView.layer.borderWidth = 1.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
