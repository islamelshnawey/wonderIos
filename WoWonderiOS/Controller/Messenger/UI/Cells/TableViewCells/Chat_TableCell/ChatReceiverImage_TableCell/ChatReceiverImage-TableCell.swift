

import UIKit

class ChatReceiverImage_TableCell: UITableViewCell {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var starBtn: UIButton!
    var delegate:PlayVideoDelegate?
    var index:Int? = nil
    var status:Bool? = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playPressed(_ sender: Any) {
        self.delegate?.playVideo(index: index ?? 0, status: true ?? false)
        
    }
}
