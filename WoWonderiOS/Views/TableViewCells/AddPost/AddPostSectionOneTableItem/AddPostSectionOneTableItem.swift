

import UIKit
import ActionSheetPicker_3_0
import SDWebImage
import WoWonderTimelineSDK

class AddPostSectionOneTableItem: UITableViewCell {
    
    @IBOutlet weak var albumBtn: RoundButton!
    @IBOutlet weak var privacyBtn: RoundButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var saveButton: UIButton!
    
    var vc:AddPostVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(){
        self.usernameLabel.text = AppInstance.instance.profile?.userData?.username ?? ""
        let url = URL(string: UserData.getImage()  ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "no-avatar"), options: [], completed: nil)
        if AppInstance.instance.isAlbumVisible{
            self.albumBtn.isHidden = false
        }else{
            self.albumBtn.isHidden = true
        }
    }
    
    func edit_bind(privacy: Int){
        self.usernameLabel.text = AppInstance.instance.profile?.userData?.username ?? ""
        let url = URL(string: UserData.getImage()  ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "no-avatar"), options: [], completed: nil)
        self.albumBtn.isHidden = true
        if (privacy == 0){
            self.privacyBtn.setTitle(NSLocalizedString("  Everyone  ", comment: "  Everyone  "), for: .normal)
        }
        else if (privacy == 1){
            self.privacyBtn.setTitle(NSLocalizedString("  People Follow me  ", comment: "  People Follow me  "), for: .normal)
        }
        else if (privacy == 2){
            self.privacyBtn.setTitle(NSLocalizedString("  People i Follow  ", comment: "  People i Follow  "), for: .normal)
        }
        else if (privacy == 3){
            self.privacyBtn.setTitle(NSLocalizedString("  Nobody  ", comment: "  Nobody  "), for: .normal)
        }
    }
    
    @IBAction func privacyPressed(_ sender: UIButton) {
        
        
        ActionSheetStringPicker.show(withTitle: NSLocalizedString("Post Privacy", comment: ""),
                                     rows: ["  Everyone  ","  People Follow me  ","  People i Follow  ","  Nobody  "],
                                     initialSelection: 0,
                                     doneBlock: { (picker, value, index) in
                                        
                                        self.privacyBtn.setTitle(index as? String, for: .normal)
                                        self.vc?.postPrivacy = value
                                        return
                                        
        }, cancel:  { ActionStringCancelBlock in return }, origin:sender)
    }
    @IBAction func albumPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddPost", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlbumNameVC") as! AlbumNameVC
        vc.delegate = self
        self.vc!.present(vc, animated: true, completion: nil)
    }
    
    
}
extension AddPostSectionOneTableItem:didSelectAlbumNameDelegate{
    func didSelectAlbumName(albumNameString: String) {
        self.albumBtn.setTitle(albumNameString, for: .normal)
    }
    
}
