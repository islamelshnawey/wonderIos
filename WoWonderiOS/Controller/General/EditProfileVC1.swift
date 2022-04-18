

import UIKit
import ZKProgressHUD
import WoWonderTimelineSDK

class EditProfileVC1: UIViewController,UITextViewDelegate,getAddressDelegate,UITextFieldDelegate {
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var workSpaceTextFeild: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var locationTextField: RoundTextView!
    @IBOutlet weak var firstNameTextFiled: UITextField!
    @IBOutlet weak var relationField: UITextField!
    
    var realtionId = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.relationField.inputView = UIView()
        self.setupUI()
    }
    private func setupUI(){
//        self.title = "Edit Profile"
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = NSLocalizedString("Edit Profile", comment: "Edit Profile")
        let save = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: #selector(Save))
        self.navigationItem.rightBarButtonItem  = save
        self.firstNameTextFiled.text = AppInstance.instance.profile?.userData?.firstName ?? ""
        self.lastNameTextField.text = AppInstance.instance.profile?.userData?.lastName ?? ""
        self.locationTextField.text = AppInstance.instance.profile?.userData?.address ?? ""
    
        self.mobileTextField.text = AppInstance.instance.profile?.userData?.phoneNumber ?? ""
        self.websiteTextField.text = AppInstance.instance.profile?.userData?.website ?? ""
        self.workSpaceTextFeild.text = AppInstance.instance.profile?.userData?.working ?? ""
        self.schoolTextField.text = AppInstance.instance.profile?.userData?.school ?? ""
        if let relationID =  AppInstance.instance.profile?.userData?.relationshipID{
            if relationID == "0"{
                self.relationField.text = NSLocalizedString("None", comment: "None")
            }
            else if relationID == "1"{
                self.relationField.text = NSLocalizedString("Single", comment: "Single")
            }
            else if (relationID == "2"){
                self.relationField.text = NSLocalizedString("In a realtionship", comment: "In a realtionship")
            }
            else if (relationID == "3"){
                self.relationField.text = NSLocalizedString("Married", comment: "Married")
            }
            else if (relationID == "4"){
                self.relationField.text = NSLocalizedString("Engaged", comment: "Engaged")
            }
        }
        self.firstNameTextFiled.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.locationTextField.text = NSLocalizedString("Location", comment: "Location")
        self.mobileTextField.placeholder = NSLocalizedString("Mobile", comment: "Mobile")
        self.websiteTextField.placeholder = NSLocalizedString("Website", comment: "Website")
        self.schoolTextField.placeholder = NSLocalizedString("School", comment: "School")
        self.locationTextField.delegate = self
        self.relationField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.relationField){
            self.relationField.resignFirstResponder()
            let alert = UIAlertController(title: "", message: NSLocalizedString("Relationship", comment: "Relationship"), preferredStyle: .actionSheet)
            alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: NSLocalizedString("None", comment: "None"), style: .default, handler: { (_) in
                self.relationField.text = NSLocalizedString("None", comment: "None")
                self.realtionId = "0"
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Single", comment: "Single"), style: .default, handler: { (_) in
                self.relationField.text = NSLocalizedString("Single", comment: "Single")
                self.realtionId = "1"
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("In a relatioship", comment: "In a relatioship"), style: .default, handler: { (_) in
                self.relationField.text = NSLocalizedString("In a relatioship", comment: "In a relatioship")
                self.realtionId = "2"
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Married", comment: "Married"), style: .default, handler: { (_) in
                self.relationField.text = NSLocalizedString("Married", comment: "Married")
                self.realtionId = "3"
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Engaged", comment: "Engaged"), style: .default, handler: { (_) in
                self.relationField.text = NSLocalizedString("Engaged", comment: "Engaged")
                self.realtionId = "4"
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
                print("User click Dismiss button")
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.locationTextField.resignFirstResponder()
        let Stroyboard =  UIStoryboard(name: "MoreSection2", bundle: nil)
        let vc = Stroyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func getAddress(address: String) {
        self.locationTextField.resignFirstResponder()
        self.locationTextField.text = address
    }
    
    @objc func Save(){
        self.updateMyProfile()
    }
    
    
    private func updateMyProfile(){
        ZKProgressHUD.show()
        let firstName = self.firstNameTextFiled.text ?? ""
        let lastName = self.lastNameTextField.text ?? ""
        let location = self.locationTextField.text ?? ""
        let mobile = self.mobileTextField.text ?? ""
        let website = self.websiteTextField.text ?? ""
        let workspace = self.workSpaceTextFeild.text ?? ""
        let school = self.schoolTextField.text ?? ""
        performUIUpdatesOnMain {
            UpdateUserManager.instance.updateProfile(firstName: firstName, lastName: lastName, mobile: mobile, website: website, workSpace: workspace, school: school,location: location, relation: self.realtionId) { (success, authError, error) in
                if success != nil {
                    AppInstance.instance.getProfile()
                    self.view.makeToast(success?.message ?? "")
                    ZKProgressHUD.dismiss()
                }
                else if authError != nil {
                    ZKProgressHUD.dismiss()
                    self.view.makeToast(authError?.errors?.errorText)
                    self.showAlert(title: "", message: (authError?.errors?.errorText)!)
                }
                else if error  != nil {
                    ZKProgressHUD.dismiss()
                    print(error?.localizedDescription)
                    
                }
            }
        }
        
    }
    
}
