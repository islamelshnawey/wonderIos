

import UIKit


class Followings_TableCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    private var status:Bool? = false
    private let color = UIColor.mainColor
    var indexPath:Int?
    var delegate:FollowUnFollowDelegate?
    var userId:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func followPressed(_ sender: Any) {
        let userID = userId ?? ""
        let index = indexPath ?? 0
        self.delegate?.followUnfollow(user_id: userID, index: index, cellBtn: followBtn!)
        
//        followBtn.layer.cornerRadius = followBtn.frame.height / 2
//        followBtn.backgroundColor = .clear
//        followBtn.layer.borderWidth = 1
//        self.status = !status!
//        if status!{
//            followBtn.backgroundColor = color
//            followBtn.setTitleColor(UIColor.white, for: .normal)
//            
//        }else{
//            followBtn.layer.borderColor = color.cgColor
//            followBtn.setTitleColor(color, for: .normal)
//        }
        
    }
    
    private func setupCell(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        followBtn.backgroundColor = .clear
        followBtn.layer.cornerRadius = followBtn.frame.height / 2
        followBtn.backgroundColor = color
        followBtn.setTitleColor(UIColor.white, for: .normal)
        if (AppInstance.instance.connectivity_setting == "0"){
            self.followBtn.setTitle(NSLocalizedString("Following", comment: "Following"), for: .normal)
        }
        else{
            self.followBtn.setTitle(NSLocalizedString("MyFriend", comment: "MyFriend"), for: .normal)
        }
//        if let checkConnectivity = AppInstance.instance.userSetting?["connectivitySystem"] as? String{
//            if checkConnectivity == "0"{
//                self.followBtn.setTitle(NSLocalizedString("following", comment: "following"), for: .normal)
//            }
//            else{
//                self.followBtn.setTitle(NSLocalizedString("My Friend", comment: "My Friend"), for: .normal)
//            }
//        }
       
        
    }
}
