

import UIKit

class ChatSenderImage_TableCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    
    var delegate:PlayVideoDelegate?
    var index:Int? = nil
    var status:Bool? = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func playPresserd(_ sender: Any) {
        self.delegate?.playVideo(index: index ?? 0, status: true    ?? false)
    }
}
