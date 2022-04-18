//
//  EnterAmountController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/30/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class EnterAmountController: UIViewController,UITextFieldDelegate {

    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var lineView: UIView!
    
    var delegate: sendDonationDelegation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountField.delegate = self
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.sendBtn.setTitle(NSLocalizedString("Send", comment: "Send"), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.sendBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.lineView.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
//        self.sendBtn.isEnabled = false
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Send(_ sender: Any) {
        let amount = Int(amountField.text ?? "0") ?? 0
        if (self.amountField.text?.isEmpty == true){
            self.view.makeToast("Please Enter Amount")
        }
        else if (amount <= 0){
            self.view.makeToast("Please Enter Amount")
        }
        else{
            self.dismiss(animated: true) {
                self.delegate?.sendAmount(amount: Int(self.amountField.text!) ?? 0)
            }
        }
    }
    
}
