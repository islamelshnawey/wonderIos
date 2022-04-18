

import UIKit

class ChatReceiverAudio_TableCell: UITableViewCell {
   
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    var delegate:PlayAudioDelegate?
    var index:Int?
    var url:String?
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
        self.status = !status!
        let url = URL(string: self.url ?? "")
        if status!{
            self.delegate?.playAudio(index: self.index ?? 0, status:status! , url: (url ?? nil)!, button: playBtn)
        }else{
            self.delegate?.playAudio(index: self.index ?? 0, status:status! , url: (url ?? nil)!, button: playBtn)
        }
    }
}
