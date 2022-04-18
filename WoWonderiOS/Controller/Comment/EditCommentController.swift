//
//  EditCommentController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/8/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD

class EditCommentController: UIViewController {

    @IBOutlet var editLbl: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var textView: RoundTextView!
    
    var comment_text = ""
    var comment_id = ""
    var delegate: editCommentDelegate?
    
    let status = Reach().connectionStatus()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        self.editLbl.text = NSLocalizedString("Edit", comment: "Edit")
        self.cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "CANCEL"), for: .normal)
        self.updateBtn.setTitle(NSLocalizedString("UPDATE", comment: "UPDATE"), for: .normal)
        if comment_text != ""{
            self.textView.text = comment_text
        }
        else{
            self.textView.placeholder = NSLocalizedString("Write a Comment", comment: "Write a Comment")
        }
        
        self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.updateBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.textView.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
//            AppInstance.instance.appColor
    }
    
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
        
    }
    
    private func editComment(){
        ZKProgressHUD.show()
        EditCommentManager.sharedInstance.editComment(comment_id: Int(self.comment_id) ?? 0, text: self.comment_text) { (success, authError, error) in
            if (success != nil){
                ZKProgressHUD.dismiss()
                self.dismiss(animated: true) {
                    self.delegate?.editComment(text: self.textView.text)
                }
            }
            else if (authError != nil){
                self.view.makeToast(authError?.errors?.errorText)
                ZKProgressHUD.dismiss()
            }
            else if (error != nil){
                self.view.makeToast(error?.localizedDescription)
                ZKProgressHUD.dismiss()
            }
        }
    }
    
    
    @IBAction func Update(_ sender: Any) {
        if self.textView.text.isEmpty == true || self.textView.text == " "{
            self.view.makeToast("Please enter Comment")
        }
        else{
            
            switch status {
            case .unknown, .offline:
                self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            case .online(.wwan), .online(.wiFi):
                self.editComment()
            }
        }
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
