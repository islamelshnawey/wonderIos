
import UIKit

class StorySectionOneTableItem: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var newStoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.statusLabel.text = NSLocalizedString("Status", comment: "Status")
        self.newStoryLabel.text = NSLocalizedString("Add new Story", comment: "Add new Story")
        self.plusView.backgroundColor = .mainColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func bind(_ object :String ){
        let url = URL.init(string:object ?? "")
        self.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
    }
}
