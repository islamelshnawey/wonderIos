
import UIKit

class FindFriends_CollectionCell: UICollectionViewCell {
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    private var status:Bool? = false
    private let color = UIColor.hexStringToUIColor(hex: "A84849")
    var indexPath:Int?
    var delegate:FollowUnFollowDelegate?
    var userId:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()

    }

    @IBAction func followPressed(_ sender: Any) {
        let userID = userId ?? ""
        let index = indexPath ?? 0
        self.delegate?.followUnfollow(user_id: userID, index: index, cellBtn: followBtn!)
    }
    private func setupCell(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        followBtn.layer.cornerRadius = followBtn.frame.height / 2
        followBtn.backgroundColor = .clear
        followBtn.borderColorV = color
        followBtn.setTitleColor(color, for: .normal)
        followBtn.setTitle("follow", for: .normal)
        
    }
}
