
import UIKit
import WoWonderTimelineSDK


class LikePagesCell : UITableViewCell {
    
    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageicon: Roundimage!
    @IBOutlet weak var pageName: UILabel!
    @IBOutlet weak var pageCategory: UILabel!
    @IBOutlet weak var likeBtn: RoundButton!
    
    /// No Page outlet
    
    @IBOutlet weak var noPageView: UIView!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var noPageLbl: UILabel!
    @IBOutlet weak var notextLabel: UILabel!
    @IBOutlet weak var searchBtn: RoundButton!
    
    var isLike = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.likeBtn.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noPageLbl.text = NSLocalizedString("No Liked Pages", comment: "No Liked Pages")
        self.notextLabel.text = NSLocalizedString("Start Viewing or create your own age", comment: "Start Viewing or create your own age")
        self.searchBtn.setTitle(NSLocalizedString("Search", comment: "Search"), for: .normal)
        self.searchBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
