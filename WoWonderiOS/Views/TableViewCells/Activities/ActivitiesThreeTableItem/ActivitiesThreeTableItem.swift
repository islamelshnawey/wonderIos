

import UIKit

class ActivitiesThreeTableItem: UITableViewHeaderFooterView {
    

    @IBOutlet weak var seeBtn: UIButton!
    @IBOutlet weak var lastLabel: UILabel!

    var vc: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lastLabel.text = NSLocalizedString("Last Activites", comment: "Last Activites")
        self.seeBtn.setTitle(NSLocalizedString("See All", comment: "See All"), for: .normal)
        self.lastLabel.textColor = UIColor.black
    }
    
    
    @IBAction func SeeAll(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LastActivityVC") as! LastActivitesController
        self.vc?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
