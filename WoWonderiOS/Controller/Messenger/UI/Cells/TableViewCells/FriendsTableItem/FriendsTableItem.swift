
import UIKit

class FriendsTableItem: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var WoWonderStringLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.WoWonderStringLabel.text = ControlSettings.WoWonderText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
