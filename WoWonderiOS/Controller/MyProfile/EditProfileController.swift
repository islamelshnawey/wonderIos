

import UIKit
import ZKProgressHUD
import Toast_Swift
import WoWonderTimelineSDK

class EditProfileController: UIViewController,UITextViewDelegate,getAddressDelegate {
    
    
    @IBOutlet weak var firstName: RoundTextField!
    @IBOutlet weak var lastName: RoundTextField!
    @IBOutlet weak var address: RoundTextView!
    @IBOutlet weak var phoneNumber: RoundTextField!
    @IBOutlet weak var website: RoundTextField!
    @IBOutlet weak var workPlace: RoundTextField!
    @IBOutlet weak var school: RoundTextField!
    
    let status = Reach().connectionStatus()
    var delegate : EditProfileDelegate!
    
    var first_Name = ""
    var last_Name = ""
    var phone_Number = ""
    var webSite = ""
    var work_Place = ""
    var schoolz = ""
    var addresss = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        self.navigationItem.title = NSLocalizedString("Edit Profile", comment: "Edit Profile")
        self.firstName.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastName.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        
        self.phoneNumber.placeholder = NSLocalizedString("Mobile", comment: "Mobile")
        self.website.placeholder = NSLocalizedString("Website", comment: "Website")
        self.school.placeholder = NSLocalizedString("School", comment: "School")
        self.workPlace.placeholder = NSLocalizedString("WorkPlace", comment: "WorkPlace")
        
        if (self.addresss == ""){
            self.address.text = NSLocalizedString("Location", comment: "Location")
        }else{
            self.address.text = self.addresss
        }
    
        self.firstName.text = self.first_Name
        self.lastName.text = self.last_Name
        self.phoneNumber.text = self.phone_Number
        self.school.text = self.schoolz
        self.website.text = self.webSite
        self.workPlace.text = self.work_Place
        self.address.delegate = self
        
        self.firstName.text = AppInstance.instance.profile?.userData?.firstName ?? ""
        self.lastName.text = AppInstance.instance.profile?.userData?.lastName ?? ""
//        self.locationTextField.text = AppInstance.instance.profile?.userData?.address ?? ""
    
        self.phoneNumber.text = AppInstance.instance.profile?.userData?.phoneNumber ?? ""
        self.website.text = AppInstance.instance.profile?.userData?.website ?? ""
        self.workPlace.text = AppInstance.instance.profile?.userData?.working ?? ""
        self.school.text = AppInstance.instance.profile?.userData?.school ?? ""
        self.firstName.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastName.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        
        self.phoneNumber.placeholder = NSLocalizedString("Mobile", comment: "Mobile")
        self.website.placeholder = NSLocalizedString("Website", comment: "Website")
        self.school.placeholder = NSLocalizedString("School", comment: "School")
        self.workPlace.placeholder = NSLocalizedString("WorkPlace", comment: "WorkPlace")
//        self.locationTextField.delegate = self
        
        
        
    }
    
    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.address.resignFirstResponder()
        let Stroyboard =  UIStoryboard(name: "MoreSection2", bundle: nil)
        let vc = Stroyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func getAddress(address: String) {
        self.address.resignFirstResponder()
        self.address.text = address
    }
    
    private func updateUserProfile() {
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
            ZKProgressHUD.dismiss()
        case .online(.wwan),.online(.wiFi):
            UpdateUserDataManager.sharedInstance.updateUserData(firstName: self.firstName.text!, lastName: self.lastName.text!, phoneNumber: self.phoneNumber.text!, website: self.website.text!, address: self.address.text!, workPlace: self.workPlace.text!, school: self.school.text!, gender: "") { (success, authError, error) in
                if success != nil {
                    print(success?.message)
                    self.delegate.editProfile(firstName: self.firstName.text!, lastName: self.lastName.text!, phone: self.phoneNumber.text!, webSite: self.website.text!, WorkPlace: self.workPlace.text!, School: self.school.text!, location : self.address.text!)
                    ZKProgressHUD.dismiss()
                    self.view.makeToast(success?.message)
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
                else if authError != nil {
                    self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    ZKProgressHUD.dismiss()
                    
                }
                else if error != nil {
                    print(error?.localizedDescription)
                    ZKProgressHUD.dismiss()
                }
                
                
            }
        }
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Save(_ sender: Any) {
        ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
        self.updateUserProfile()
    }
    
}
