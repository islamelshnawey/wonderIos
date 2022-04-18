

import UIKit

class StorySectionThreeTableItem: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cameraIamge: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cameraIamge.tintColor = .mainColor
     
        self.titleLabel.text = NSLocalizedString("There are no stories", comment: "")
              self.descriptionLabel.text = NSLocalizedString("Photos and videos shared in stories are only visible for 24 hours after they have been added.", comment: "")
           
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
