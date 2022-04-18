
import UIKit

class BlockedUsers_TableCell: UITableViewCell {
      @IBOutlet weak var usernameLabel: UILabel!
 
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
