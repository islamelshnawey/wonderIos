

import UIKit

class SelectContact_TableCell: UITableViewCell {
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var delegate:SelectContactCallsDelegate!
    var indexPath:Int? = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.callBtn.tintColor = .ButtonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    @IBAction func videoCallPressed(_ sender: Any) {
        self.delegate.selectCalls(index: self.indexPath ?? 0, type: "video")
        
    }
    @IBAction func audioCallPressed(_ sender: Any) {
         self.delegate.selectCalls(index: self.indexPath ?? 0, type: "audio")
    }
    
    
}
