//
//  RegisterTableItem.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/25/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import WoWonderTimelineSDK

class RegisterTableItem: UITableViewCell {
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderBtn: UIButton!
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var doHaveAnAccount: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPassTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var vc:RegisterVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.applyBlurEffect()
        loginBtn.addBlurEffect()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        firstnameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastnameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confrimPassTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
//        genderTextField.attributedPlaceholder = NSAttributedString(string: "Gender",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        loginBtn.setTitle(NSLocalizedString("Create Account", comment: "Create Account"), for: .normal)
        
        let attributedTitle = NSMutableAttributedString(string: "By creating an account you agree to our", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSMutableAttributedString(string: "Terms & Conditions", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.red]))
        registerBtn.setAttributedTitle(attributedTitle, for: .normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func termsConditonClicked(_ sender: Any) {
        if let url = URL(string: "\(APIClient.baseURl)/terms/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderPressed(_ sender: Any){
        self.setGender()
    }
    
    @IBAction func loginClicked(_ sender: Any){
        self.vc?.Register()
    }
    
    func setGender(){
        self.genderTextField.inputView = UIView()
        self.genderTextField.resignFirstResponder()
        let alert = UIAlertController(title: "", message: NSLocalizedString("Gender optional", comment: "Gender optional"), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Male", comment: "Male"), style: .default, handler: { (_) in
            self.genderBtn.setTitle(NSLocalizedString("Male", comment: "Male"), for: .normal)
         }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Female", comment: "Female"), style: .default, handler: { (_) in
            
            self.genderBtn.setTitle(NSLocalizedString("Female", comment: "Female"), for: .normal)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
            self.genderTextField.resignFirstResponder()
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.vc!.view
            popoverController.sourceRect = CGRect(x: self.vc!.view.bounds.midX, y: self.vc!.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.vc?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
