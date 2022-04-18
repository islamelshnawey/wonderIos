//
//  ForgetPasswordTableItem.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/25/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class ForgetPasswordTableItem: UITableViewCell {

    @IBOutlet weak var forgetPasswordBottonLabel: UILabel!
    @IBOutlet weak var forgetPasswordToplabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var blurView: UIImageView!
    
    var vc:ForgotPasswordVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.blurView.applyBlurEffect()
        self.loginBtn.addBlurEffect()
        self.forgetPasswordToplabel.text = NSLocalizedString("Forgot Password?", comment: "Forgot Password?")
        self.forgetPasswordBottonLabel.text = NSLocalizedString("Please enter your email address. You will receive a link to create  a new password.", comment: "Please enter your email address. You will receive a link to create  a new password.")
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.placeholder = NSLocalizedString("Enter your Email", comment: "Enter your Email")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func loginPressed(_ sender: Any) {
        if self.emailTextField.text!.isEmpty == true {
            print("Error")
            self.vc?.error = NSLocalizedString("Please Enter Your Emai", comment: "Please Enter Your Emai")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.vc?.error ?? ""
            self.vc?.present(vc!, animated: true, completion: nil)
            }else if !(isValidEmail(testStr: self.emailTextField.text ?? "")){
            
            self.vc?.error = NSLocalizedString("Please Write your Full email address", comment: "Please Write your Full email address")
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.vc?.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            self.vc?.present(vc!, animated: true, completion: nil)
            }
        else {
            self.vc?.forgetPassword(email: self.emailTextField.text  ?? "")
        }
    }
    @IBAction func backPressed(_ sender: Any) {
        self.vc?.navigationController?.popViewController(animated: true)
    }
}
