

import UIKit
import OneSignal
import WoWonderTimelineSDK
class SettingsSectionThreeTableItem: UITableViewCell {
    
    @IBOutlet weak var Switchlabel: UISwitch!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var privacyVC:SettingsVC1?
    var TypeString:String? = ""
    var value:Int? = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Switchlabel.onTintColor = .mainColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if self.TypeString == "notification"{
            if self.value == 0{
                self.value = 1
                self.Switchlabel.setOn(true, animated: true)
                UserDefaults.standard.setNotificationStatus(value: true, ForKey: Local.NOTIFICATION_RECEIVE.NotificationReceive)
                OneSignal.setSubscription(true)
            }else{
                
                self.Switchlabel.setOn(false, animated: true)
                self.value = 0
                UserDefaults.standard.setNotificationStatus(value: false, ForKey: Local.NOTIFICATION_RECEIVE.NotificationReceive)
                OneSignal.setSubscription(false)
            }
        }else{
            if self.value == 0{
                self.value = 1
                self.Switchlabel.setOn(true, animated: true)
                self.privacyVC?.updateprivacy(Type: self.TypeString ?? "", value: self.value ?? 0)
            }else{
                
                self.Switchlabel.setOn(false, animated: true)
                self.value = 0
                self.privacyVC?.updateprivacy(Type: self.TypeString ?? "", value: self.value ?? 0)
            }
        }
        
        
    }
}
