
import UIKit

class ChatInfoTableItem: UITableViewCell {

    @IBOutlet weak var deliverLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
