//
//  ForgotPasswordVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/25/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD
import WoWonderTimelineSDK
class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var error = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
   
    private func setupUI(){
        self.tableView.register(UINib(nibName: "ForgetPasswordTableItem", bundle: nil), forCellReuseIdentifier: "ForgetPasswordTableItem")
    }
     func forgetPassword(email : String){
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.error = "Internet Connection Failed"
            let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
            vc?.error = self.error ?? ""
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)    case .online(.wwan), .online(.wiFi):
            ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
            ForgetPasswordManager.sharedInstance.forgetPassword(email: email) { (success, authError, error) in
                
                if success != nil {
                    ZKProgressHUD.dismiss()
                    self.error = "EMAIL HAS BEEN SEND"
                    let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
                    vc?.error = self.error ?? ""
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                    
                }
                    
                else if authError != nil {
                    ZKProgressHUD.dismiss()
                    self.error = authError?.errors.errorText ?? ""
                    let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: "SecurityController") as? SecurityController
                    vc?.error = self.error ?? ""
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                    print(authError?.errors.errorText)
                }
                    
                else if error != nil {
                    ZKProgressHUD.dismiss()
                    print("error")
                    
                }
                
            }
        }
    }
}

extension ForgotPasswordVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForgetPasswordTableItem" ) as? ForgetPasswordTableItem
        cell!.vc = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 720.0
    }
}
