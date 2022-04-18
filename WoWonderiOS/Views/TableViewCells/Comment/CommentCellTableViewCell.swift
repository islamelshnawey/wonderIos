
import UIKit
import WoWonderTimelineSDK


class CommentCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    @IBOutlet weak var viewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet var noImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var designView: DesignView!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var noCommentsLAbel: UILabel!
    @IBOutlet weak var noCommentView: UIView!
    @IBOutlet weak var reactionImage: UIImageView!
    @IBOutlet weak var reactionCount: UILabel!
    @IBOutlet weak var reactionBtn: UIButton!
    @IBOutlet var audioView: UIView!
    @IBOutlet var audioViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var audioTimer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noCommentsLAbel.text = NSLocalizedString("No Comments to be displayed", comment: "No Comments to be displayed")
        self.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
