//
//  RegisterVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/25/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import ZKProgressHUD

class RegisterVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var error = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        print("OneSignal device id = \(self.oneSignalID ?? "")")
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    private func setupUI(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loginImage")
        backgroundImage.contentMode = .redraw
        self.view.insertSubview(backgroundImage, at: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "RegisterTableItem", bundle: nil), forCellReuseIdentifier: "RegisterTableItem")
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    
    func showErrorPopup(error:String){
        let vc = R.storyboard.authentication.securityController()
        vc?.error = error
        self.present(vc!, animated: true, completion: nil)
    }
    
    func Register() {
        
        guard let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? RegisterTableItem else { return }
        if cell.usernameTextField.text?.isEmpty == true {
            self.error = NSLocalizedString("Error, Required Username", comment: "Error, Required Username")
            self.showErrorPopup(error: self.error)
        }
        
        else if cell.firstnameTextField.text?.isEmpty == true{
            self.error = NSLocalizedString("Error, Required FirstName", comment: "Error, Required FirstName")
            self.showErrorPopup(error: self.error)
        }
        else if cell.lastnameTextField.text?.isEmpty == true{
            self.error = NSLocalizedString("Error, Required LastName", comment: "Error, Required LastName")
            self.showErrorPopup(error: self.error)
        }
        else if cell.emailTextField.text?.isEmpty == true{
            self.error = NSLocalizedString("Error, Required Email", comment: "Error, Required Email")
            self.showErrorPopup(error: self.error)
        }
        else if cell.passwordTextField.text?.isEmpty == true{
            self.error = NSLocalizedString("Error, Required Password", comment: "Error, Required Password")
            self.showErrorPopup(error: self.error)
        }
        else if cell.confrimPassTextField.text?.isEmpty == true{
            self.error = NSLocalizedString("Error, Required ConfirmPassword", comment: "Error, Required ConfirmPassword")
            self.showErrorPopup(error: self.error)
        }
        else {
            ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
            self.signUPAuthentication(userName: cell.usernameTextField.text!, email: cell.emailTextField.text!, password: cell.passwordTextField.text!, confirmPassword: cell.confrimPassTextField.text!, deviceID: self.oneSignalID ?? "")
        }
        
    }
    
    private func updateUserData(){
        guard let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? RegisterTableItem else { return }
        UpdateUserDataManager.sharedInstance.updateUserData(firstName: cell.firstnameTextField.text!, lastName: cell.lastnameTextField.text!, phoneNumber: "", website: "", address: "", workPlace: "", school: "", gender: cell.genderTextField.text!) { (success,authError , error) in
            if success != nil{
                print(success?.message)
            }
            else if authError != nil {
                print(authError?.errors.errorText)
            }
            else if error != nil{
                print(error?.localizedDescription)
            }
        }
       
    }

    private func signUPAuthentication(userName : String,email : String, password : String,confirmPassword : String,deviceID:String) {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.error = NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed")
            self.showErrorPopup(error: self.error)
        case .online(.wwan), .online(.wiFi):
            
            AuthenticationManager.sharedInstance.signUPAuthentication(userName: userName, password: password, email: email, confirmPassword: confirmPassword,deviceId:deviceID) { (success, authError, error) in
                if success != nil {
                    UserData.setUSER_ID(success?.userID)
                    UserData.setaccess_token(success?.accessToken)
                    self.updateUserData()
                    ZKProgressHUD.dismiss()
                    AppInstance.instance.getProfile()
                    let vc = R.storyboard.authentication.introController()
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc!, animated: true, completion: nil)
                    print("SignUp Succesfull")
                }
                else if authError != nil {
                    ZKProgressHUD.dismiss()
                    self.error = authError?.errors.errorText ?? ""
                    self.showErrorPopup(error: self.error)
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

extension RegisterVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableItem" ) as? RegisterTableItem
        cell!.vc = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900.0
        
    }
    
}
