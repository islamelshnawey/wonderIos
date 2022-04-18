//
//  CreateLiveController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/16/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class CreateLiveController: UIViewController {

    @IBOutlet var streamLbl: UILabel!
    @IBOutlet var streamNameField: UITextField!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var lineView: UIView!
    
    var delegate: createLiveDelegate?
    let status = Reach().connectionStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        // Do any additional setup after loading the view.
        
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.startBtn.setTitle(NSLocalizedString("Start", comment: "Start"), for: .normal)
        self.streamNameField.placeholder = NSLocalizedString("Enter Stream name", comment: "Enter Stream name")
        self.streamLbl.text = NSLocalizedString("Stream Name", comment: "Stream Name")
    
        self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.startBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.lineView.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
    }
    
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
        
    }

    @IBAction func Start(_ sender: Any) {
        
        switch status {
        case .unknown, .offline:
//            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            if (self.streamNameField.text?.isEmpty == true) || (self.streamNameField.text == " "){
                self.view.makeToast(NSLocalizedString("Please, enter stream name", comment: "Please, enter stream name"))
            }
            else{
                self.dismiss(animated: true) {
                    self.delegate?.createLive(name: self.streamNameField.text!)
                }
            }
            
        }
        
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
