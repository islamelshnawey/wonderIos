

import UIKit
import ActiveLabel
import WoWonderTimelineSDK

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var statusLabel: ActiveLabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var productDetailBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var commentsCountBtn: UIButton!
    @IBOutlet weak var sharesCountBtn: UIButton!
    @IBOutlet weak var likeandcommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
        self.CommentBtn.setTitle("\(" ")\(NSLocalizedString("Comment", comment: "Comment"))", for: .normal)
        self.ShareBtn.setTitle("\(" ")\(NSLocalizedString("Share", comment: "Share"))", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
