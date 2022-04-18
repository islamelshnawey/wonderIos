

import UIKit

class SelectLanguage_TableCell: UITableViewCell {
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    var delegate:SelectLanguageDelegate!
    var indexPath:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func selectBtnPressed(_ sender: Any) {
        self.delegate.selectLanguage(index: indexPath, Button: selectBtn)
    }
    
}
