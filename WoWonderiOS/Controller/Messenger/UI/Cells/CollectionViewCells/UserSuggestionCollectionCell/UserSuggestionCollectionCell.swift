

import UIKit

class UserSuggestionCollectionCell: UICollectionViewCell {
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var status:Bool? = false
    private let color = UIColor.hexStringToUIColor(hex: "A84849")
    var indexPath:Int?
    var delegate:FollowUnFollowDelegate?
    var userId:String?
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    @IBAction func followPressed(_ sender: Any) {
        let userID = userId ?? ""
        let index = indexPath ?? 0
        self.delegate?.followUnfollow(user_id: userID, index: index, cellBtn: followBtn!)
    }
     func setupCell(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        followBtn.layer.cornerRadius = followBtn.frame.height / 2
        followBtn.backgroundColor = .clear
        followBtn.borderColorV = color
        followBtn.setTitleColor(color, for: .normal)
        followBtn.setTitle("follow", for: .normal)
        
}
}
