
import UIKit
import WoWonderTimelineSDK


class SharePostCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var nameLabel: UILabel!
    
    var texts = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        self.textView.text = NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView.text == NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention"){
        self.textView.text = ""
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text == ""{
            self.textView.text = NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")
        }
        else {
            self.texts = self.textView.text!
        }
    }
  
}
