

import UIKit
import ActiveLabel
import WoWonderTimelineSDK


class NormalPostCell: UITableViewCell {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: ActiveLabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var isProIcon: UIImageView!
    @IBOutlet weak var widthContraint: NSLayoutConstraint!
    @IBOutlet weak var MoreBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var commentsCountBtn: UIButton!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var sharesCountBtn: UIButton!
    @IBOutlet weak var likeandcommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    var flag = true
    var tempText = ""
    var tempFlag = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
        self.CommentBtn.setTitle("\(" ")\(NSLocalizedString("Comment", comment: "Comment"))", for: .normal)
        self.ShareBtn.setTitle("\(" ")\(NSLocalizedString("Share", comment: "Share"))", for: .normal)
        self.locationLabel.isHidden = true
        self.iconImage.isHidden = true
        
        self.statusLabel.sizeToFit()
    }
    
//    override func layoutSubviews() {
//            print("=================")
//            self.tempText = self.statusLabel.text!
//            if self.tempText.count > 100 {
//                self.seeMoreBtn.isHidden = false
//                self.statusLabel.text = getHeading(tempText: self.tempText) + "..."
//            }
//            else {
//                self.seeMoreBtn.isHidden = true
//            }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func getHeading(tempText: String) -> String {
        let index = tempText.index(tempText.startIndex, offsetBy: 100)
        let mySubstring = tempText[..<index]
        
        return String(mySubstring)
    }
    
    func getTrailing(tempText: String) -> String {
        let indexTemp = tempText.count - 100
        let index = tempText.index(tempText.endIndex, offsetBy: -indexTemp)
        let mySubstring = tempText[index...] // playground
        
        return String(mySubstring)
    }
    
    @IBAction func seeMoreBtnAction(_ sender: Any) {
        print(tempFlag)
        if flag {
            self.seeMoreBtn.setTitle("See more", for: .normal)
//            self.statusLabel.frame.size.height = 40
//            self.frame.size.height = 200
            self.statusLabel.text = getHeading(tempText: self.tempText) + "..."
            print(self.tempText)
            flag = false
        }
        else {
            self.seeMoreBtn.setTitle("See less", for: .normal)
//            self.statusLabel.frame.size.height = CGFloat(20 * Int(self.tempText.count / 65))
//            self.frame.size.height = 300
            self.statusLabel.text = self.tempText
            print(self.tempText)
            flag = true
        }
    }
}
