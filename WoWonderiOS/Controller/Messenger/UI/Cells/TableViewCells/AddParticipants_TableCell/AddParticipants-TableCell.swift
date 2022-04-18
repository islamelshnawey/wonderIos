
import UIKit

class AddParticipants_TableCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var delegate: didSelectParticipantDelegate?
    var searchArray = [SearchModel.User]()
    var userArray = [FollowingModel.Following]()
    var selectParticipantArray = [AddParticipantModel]()
    
    private var status:Bool? = false
    var searchStatus:Bool?  = false
    var indexPath:Int? = 0
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkPressed(_ sender: Any) {
        self.status = !status!
        if !searchStatus!{
            self.userArray.forEach { (it) in
                let user = AddParticipantModel(id: Int(it.id ?? "0"), profileImage: it.avatar ?? "", username: it.username ?? "")
                self.selectParticipantArray.append(user)
            }
        }else{
            self.searchArray.forEach { (it) in
                let user = AddParticipantModel(id: Int(it.userID ?? "0"), profileImage: it.avatar ?? "", username: it.username ?? "")
                self.selectParticipantArray.append(user)
            }
        }
        if status!{
            self.delegate?.selectParticipant(Image: checkBtn, status: status ?? false, idsArray: self.selectParticipantArray, Index: indexPath!)
        }else{
           self.delegate?.selectParticipant(Image: checkBtn, status: status ?? false, idsArray: self.selectParticipantArray, Index: indexPath!)
        }
    }
}
