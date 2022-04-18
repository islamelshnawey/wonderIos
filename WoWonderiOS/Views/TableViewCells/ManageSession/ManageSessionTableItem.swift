

import UIKit
import ZKProgressHUD
import WoWonderTimelineSDK

class ManageSessionTableItem: UITableViewCell {
    
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var lastSeenlabel: UILabel!
    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var roundImage: Roundimage!
    @IBOutlet weak var cancelBtn: RoundButton!
    var object : SessionModel.Datum?
    
    var singleCharacter :String?
    var indexPath:Int? = 0
    var vc: ManageSessionVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundImage.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.cancelBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object:SessionModel.Datum, index:Int){
        self.object = object
        self.indexPath = index
        
        self.phoneLabel.text = "Phone : \(object.platform ?? "")"
        self.phoneLabel.text = "Browser : \(object.browser ?? "")"
        self.phoneLabel.text = "Last seen : \(object.time ?? "")"
        if object.browser == nil{
            self.alphaLabel.text = self.singleCharacter ?? ""
        }else{
            for (index, value) in (object.browser?.enumerated())!{
                if index == 0{
                    self.singleCharacter = String(value)
                    break
                }
            }
            self.alphaLabel.text = self.singleCharacter ?? ""
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.deleteSession()
        
    }
    private func deleteSession(){
        let id = self.object?.id ?? ""
        performUIUpdatesOnMain {
            SessionManager.instance.deleteSession(type: "delete", id: id) { (success, authError, error) in
                if success != nil {
                    self.vc?.sessionArray.remove(at: self.indexPath ?? 0)
                       self.vc?.tableView.reloadData()
                    ZKProgressHUD.dismiss()
                    
                }
                else if authError != nil {
                    ZKProgressHUD.dismiss()
                     self.vc?.view.makeToast(authError?.errors?.errorText)
                     self.vc?.showAlert(title: "", message: (authError?.errors?.errorText)!)
                }
                else if error  != nil {
                    ZKProgressHUD.dismiss()
                    print(error?.localizedDescription)
                    
                }
            }
            
        }
        
        
    }
}
