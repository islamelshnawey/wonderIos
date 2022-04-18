//
//  PaystackEmailController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/30/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class PaystackEmailController: UIViewController {
    
    
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var  cancelBtn: UIButton!
    @IBOutlet weak var  sendBtn: UIButton!
    
    var delegate: paystackDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.placeholder = NSLocalizedString("Email", comment: "Email")
        self.payLabel.text = NSLocalizedString("Paystack", comment: "Paystack")
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.sendBtn.setTitle(NSLocalizedString("Pay Now", comment: "Pay Now"), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.sendBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        

    }

    @IBAction func Cancel(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func Pay(_ sender: UIButton){
        
        if (self.emailField.text?.isEmpty == true){
            self.view.makeToast("Please Enter Email")
        }
        
        else if !(isValidEmail(testStr: self.emailField.text!)){
            self.view.makeToast("Please Enter Valid Email Address")
        }
        
        else{
            self.dismiss(animated: true) {
                self.delegate?.sendEmail(email: self.emailField.text!)
            }
        }
    }

    
}
