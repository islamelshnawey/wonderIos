
import UIKit
import WoWonderTimelineSDK
class SettingSectionFourTableItem: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var status:Bool? = false
    var vc:SettingsVC1?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func checkPRessed(_ sender: Any) {
        if status!{
             UserDefaults.standard.setConversationTone(value: false, ForKey: Local.CONVERSATION_TONE.ConversationTone)
            vc?.tableView.reloadData()
        }else{
             UserDefaults.standard.setConversationTone(value: true, ForKey: Local.CONVERSATION_TONE.ConversationTone)
            vc?.tableView.reloadData()

        }
    }
    
}
