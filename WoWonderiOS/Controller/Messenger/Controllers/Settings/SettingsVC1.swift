

import UIKit
import WoWonderTimelineSDK
import ActionSheetPicker_3_0
import Async
import OneSignal

class SettingsVC1: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var darkModeCount:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "General"
        self.setupUI()
    }
    
    private func setupUI(){
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = NSLocalizedString("General", comment: "General")
        
        tableView.register( R.nib.settingsSectionOneTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier)
        tableView.register( R.nib.settingsSectionTwoTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier)
        tableView.register( R.nib.settingsSectionThreeTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier)
        tableView.register( R.nib.settingSectionFourTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingSectionFourTableItem.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    private func showActionSheetContoller (Type:String){
        if Type == "follow"{
            self.followPrivacy(Type: Type)
        }else if Type == "message"{
            self.messagePrivacy(Type: Type)
        }else if Type == "birthday"{
            self.birthdayPrivacy(Type: Type)
        }
    }
    private func followPrivacy(Type:String){
       
        ActionSheetMultipleStringPicker.show(withTitle: NSLocalizedString("Follow Privacy", comment: "Follow Privacy"), rows: [
            [NSLocalizedString("Everyone", comment: "Everyone"), NSLocalizedString("People i Follow", comment: "People i Follow")]
            
            ], initialSelection: [Int(AppInstance.instance.userProfile?.followPrivacy ?? "0")], doneBlock: {
                
                picker, indexes, values in
                let index =  (indexes![0] as? Int)!
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? SettingsSectionOneTableItem
                if index == 0{
                    cell!.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  index == 1{
                    cell!.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                }
                
                
                self.updateprivacy(Type: Type, value:(indexes![0] as? Int)!)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        
    }
    
    private func messagePrivacy(Type:String){
       
        ActionSheetMultipleStringPicker.show(withTitle: NSLocalizedString("Message Privacy", comment: "Message Privacy"), rows: [
            [NSLocalizedString("Everyone", comment: "Everyone"), NSLocalizedString("People i Follow", comment: "People i Follow"),NSLocalizedString("Nobody", comment: "Nobody")]
            
            ], initialSelection: [Int(AppInstance.instance.userProfile?.messagePrivacy ?? "0")], doneBlock: {
                picker, indexes, values in
                let index =  (indexes![0] as? Int)!
                let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as? SettingsSectionOneTableItem
                if index == 0{
                    cell!.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  index == 1{
                    cell!.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                    
                }else if  index == 2{
                    cell!.descriptionLabel.text = NSLocalizedString("Nobody", comment: "Nobody")
                    
                }
                self.updateprivacy(Type: Type, value:(indexes![0] as? Int)!)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        
    }
    
    
    private func birthdayPrivacy(Type:String){
        ActionSheetMultipleStringPicker.show(withTitle: NSLocalizedString("birthday Privacy", comment: "birthday Privacy"), rows: [
            [NSLocalizedString("Everyone", comment: "Everyone"), NSLocalizedString("People i Follow", comment: "People i Follow"),NSLocalizedString("Nobody", comment: "Nobody")]
            
            ], initialSelection: [Int(AppInstance.instance.userProfile?.birthPrivacy ?? "0")], doneBlock: {
                picker, indexes, values in
                let index =  (indexes![0] as? Int)!
                let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 3)) as? SettingsSectionOneTableItem
                if index == 0{
                    cell!.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  index == 1{
                    cell!.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                    
                }else if  index == 2{
                    cell!.descriptionLabel.text = NSLocalizedString("Nobody", comment: "Nobody")
                    
                }
                self.updateprivacy(Type: Type, value:(indexes![0] as? Int)!)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        
    }
    
    
    private func darkMode(){
        let status = UserDefaults.standard.getDarkMode(Key: "darkMode")
        
        if status{
            darkModeCount = 0
        }else{
            darkModeCount = 1
        }
        ActionSheetMultipleStringPicker.show(withTitle: "Theme", rows: [
            [NSLocalizedString("Dark mode", comment: "Dark mode"), NSLocalizedString("Light mode", comment: "Light mode")]
            
            ], initialSelection: [self.darkModeCount ?? 0], doneBlock: {
                picker, indexes, values in
                let index =  (indexes![0] as? Int)!
                if index == 0{
                    self.appDelegate.window?.overrideUserInterfaceStyle = .dark
                    
                    UserDefaults.standard.setDarkMode(value: true, ForKey: "darkMode")
                }else if  index == 1{
                    self.appDelegate.window?.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.setDarkMode(value: false, ForKey: "darkMode")
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
    }
    func updateprivacy(Type:String,value:Int){
        var key:String? = ""
        if Type == "follow"{
            key = "follow_privacy"
        }else if Type == "message"{
            key = "message_privacy"
            
        }else if Type == "birthday"{
            key = "birth_privacy"
        }
        else if Type == "status"{
            key = "message_privacy"
        }
        let sessionToken = AppInstance.instance.sessionId ?? ""
        
        Async.background({
            SettingsManager.instance.updatePrivacy(session_Token: sessionToken, key: key ?? "", value: value) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                           AppInstance.instance.fetchUserProfile(pass: nil)
                            self.view.makeToast(success?.message ?? "")
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText ?? "")
                            log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            log.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
        
    }
    private func openLink(Url:String){
        let url = URL(string: Url)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
    }
    private func deleteAccount(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let password = UserDefaults.standard.getPassword(Key: Local.USER_SESSION.Current_Password)
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            UserManager.instance.deleteUser(sessionToken: sessionToken, password: password, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main{
                        self.dismissProgressDialog{
                            log.verbose("Success = \(success?.message ?? "")")
                            UserDefaults.standard.clearUserDefaults()
//                            let vc = R.storyboard.main.main()
//                            self.appDelegate.window?.rootViewController = vc
//                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }else if sessionError != nil{
                    Async.main{
                        self.dismissProgressDialog {
                            log.verbose("session Error = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                        }
                    }
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            log.verbose("serverError = \(serverError?.errors?.errorText)")
                            self.view.makeToast(serverError?.errors?.errorText ?? "")
                            
                        }
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.verbose("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        }
                    })
                }
                
            })
            
        })
    }
    private func logout(){
        let alert = UIAlertController(title: NSLocalizedString("Logout", comment: "Logout"), message: NSLocalizedString("Are you sure you want to logout ?", comment: "Are you sure you want to logout ?"), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let logout = UIAlertAction(title: NSLocalizedString("Logout", comment: "Logout"), style: .destructive) { (action) in
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion: nil)
    }
    private func deleteAccountPressed(){
        
        let alert = UIAlertController(title: NSLocalizedString("Warning !", comment: ""), message:  NSLocalizedString("Are you sure you want to delete the account from Chats", comment: ""), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let logout = UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete"), style: .destructive) { (action) in
            self.deleteAccount()
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func update() {
        UserDefaults.standard.removeValuefromUserdefault(Key: Local.USER_SESSION.User_Session)
//        let vc = R.storyboard.main.main()
//        appDelegate.window?.rootViewController = vc
//        self.dismiss(animated: true, completion: nil)
        
    }
}
extension SettingsVC1: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = R.storyboard.settings.editProfileVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            case 1:
                let vc = R.storyboard.settings.aboutMeVC()
                self.present(vc!, animated: true, completion: nil)
                
            case 2:
                let vc = R.storyboard.settings.myAccountVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            case 3:
                let vc = R.storyboard.dashboard.blockedUsersVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            default:
                let vc = R.storyboard.dashboard.blockedUsersVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = R.storyboard.settings.changePasswordVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            case 1:
                let vc = R.storyboard.settings.twoFactorVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            case 2:
                let vc = R.storyboard.settings.manageSessionVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            default:
                let vc = R.storyboard.settings.changePasswordVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.darkMode()
                
            default:
                let vc = R.storyboard.settings.changePasswordVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        case 3:
            switch indexPath.row {
            case 0:
                self.showActionSheetContoller(Type: "follow")
                
            case 1:
                self.showActionSheetContoller(Type: "message")
                
            case 2:
                self.showActionSheetContoller(Type: "birthday")
                
            default:
                let vc = R.storyboard.settings.changePasswordVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        case 5:
            switch indexPath.row {
            case 0:
                let vc = R.storyboard.dashboard.inviteFriendsVC()
                vc?.status = true
                vc?.key = "settings"
                self.present(vc!, animated: true, completion: nil)
            case 1:
                
                let callLogs = UserDefaults.standard.getCallsLogs(Key: Local.CALL_LOGS.CallLogs)
                if callLogs.isEmpty{
                    self.view.makeToast(NSLocalizedString("There are no call Logs to clear", comment: "There are no call Logs to clear"))
                }else{
                    UserDefaults.standard.removeValuefromUserdefault(Key: Local.CALL_LOGS.CallLogs)
                    self.view.makeToast(NSLocalizedString("Call Logs Cleared", comment: "Call Logs Cleared"))
                }
            default:
                break
            }
        case 6:
            switch indexPath.row {
            case 0:
                self.openLink(Url: ControlSettings.HelpLink)
                
            case 1:
                self.openLink(Url: ControlSettings.reportlink)
            case 2:
                self.deleteAccountPressed()
            case 3:
                self.logout()
                
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
        view.backgroundColor = UIColor.systemBackground
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
        separatorView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E1E1E1")
        
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.size.width, height: 48))
        label.textColor = UIColor.mainColor
        label.font = UIFont(name: "Arial", size: 17)
        if section == 0{
            label.text = NSLocalizedString("Account and Profile", comment: "Account and Profile")
            
        }else if section == 1 {
            label.text = NSLocalizedString("Security", comment: "Security")
        }else if section == 2 {
            label.text = NSLocalizedString("Display", comment: "Display")
        }else if section == 3 {
            label.text = NSLocalizedString("Privacy", comment: "Privacy")
        }else if section == 4 {
            label.text = NSLocalizedString("Message Notification", comment: "Message Notification")
        }else if section == 5 {
            label.text = NSLocalizedString("General", comment: "General")
        } else if section == 6 {
            label.text = NSLocalizedString("Support", comment: "Support")
        }
        view.addSubview(separatorView)
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
}

extension SettingsVC1: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 4
        case 1: return 3
        case 2: return 1
        case 3: return 3
        case 4: return 3
        case 5: return 2
        case 6: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Edit Profile and avatar", comment: "Edit Profile and avatar")
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier) as! SettingsSectionOneTableItem
                cell.titleLabel.text = NSLocalizedString("About", comment: "About")
                cell.descriptionLabel.text = AppInstance.instance.userProfile?.about ?? ""
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("My Account", comment: "My Account")
                
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Blocked Users", comment: "Blocked Users")
                return cell
            default:
                return UITableViewCell()
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier) as! SettingsSectionOneTableItem
                cell.titleLabel.text = NSLocalizedString("Password", comment: "Password")
                cell.descriptionLabel.text = NSLocalizedString("Change your password", comment: "Change your password")
                return cell
                
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
                
                return cell
                
            default:
                return UITableViewCell()
            }
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Theme", comment: "Theme")
                return cell
                
                
            default:
                return UITableViewCell()
            }
            
        case 3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier) as! SettingsSectionOneTableItem
                cell.titleLabel.text = NSLocalizedString("Who can follow me?", comment: "Who can follow me?")
                if AppInstance.instance.userProfile?.followPrivacy == "0"{
                    cell.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  AppInstance.instance.userProfile?.followPrivacy == "1"{
                    cell.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier) as! SettingsSectionOneTableItem
                cell.titleLabel.text = NSLocalizedString("Who can message me?", comment: "Who can message me?")
                if AppInstance.instance.userProfile?.messagePrivacy == "0"{
                    cell.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  AppInstance.instance.userProfile?.messagePrivacy == "1"{
                    cell.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                }else if  AppInstance.instance.userProfile?.messagePrivacy == "2"{
                    cell.descriptionLabel.text = NSLocalizedString("Nobody", comment: "Nobody")
                }
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionOneTableItem.identifier) as! SettingsSectionOneTableItem
                cell.titleLabel.text = NSLocalizedString("Who can see my birthday?", comment: "Who can see my birthday?")
                if AppInstance.instance.userProfile?.birthPrivacy == "0"{
                    cell.descriptionLabel.text = NSLocalizedString("Everyone", comment: "Everyone")
                }else if  AppInstance.instance.userProfile?.birthPrivacy == "1"{
                    cell.descriptionLabel.text = NSLocalizedString("People i Follow", comment: "People i Follow")
                }else if AppInstance.instance.userProfile?.birthPrivacy == "2"{
                    cell.descriptionLabel.text = NSLocalizedString("Nobody", comment: "Nobody")
                }
                return cell
            default:
                return UITableViewCell()
            }
        case 4:
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.settingsSectionThreeTableItem.identifier ) as! SettingsSectionThreeTableItem
                cell.titleLabel.text = NSLocalizedString("Notification Popup", comment: "Notification Popup")
                cell.descriptionLabel.text = NSLocalizedString("get Notification when you receive messages", comment: "get Notification when you receive messages")
                cell.TypeString = "notification"
                let status =   UserDefaults.standard.getNotification(Key: Local.NOTIFICATION_RECEIVE.NotificationReceive)
                if status{
                    cell.Switchlabel.isOn = true
                    cell.value = 1
                }else{
                    cell.Switchlabel.isOn = false
                    cell.value = 0
                }
                cell.TypeString = "notification"
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.settingsSectionThreeTableItem.identifier ) as! SettingsSectionThreeTableItem
                cell.titleLabel.text = NSLocalizedString("Show online users", comment: "Show online users")
                cell.descriptionLabel.text = NSLocalizedString("Show when user are online", comment: "Show when user are online")
                if AppInstance.instance.userProfile?.status == "0"{
                    cell.Switchlabel.isOn = true
                    cell.value = 0
                }else if AppInstance.instance.userProfile?.status == "1"{
                    cell.Switchlabel.isOn = true
                    cell.value = 1
                }
                cell.privacyVC = self
                cell.TypeString = "status"
                
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingSectionFourTableItem.identifier) as! SettingSectionFourTableItem
                cell.titleLabel.text = NSLocalizedString("Conversation Tones", comment: "Conversation Tones")
                cell.descriptionLabel.text = NSLocalizedString("Play sound for incoming and outgoing messages", comment: "Play sound for incoming and outgoing messages")
                let status = UserDefaults.standard.getConversationTone(Key: Local.CONVERSATION_TONE.ConversationTone)
                cell.status = status
                cell.checkBtn.tintColor = .ButtonColor
                cell.vc = self
                if status{
                    cell.checkBtn.setImage(R.image.ic_check_red()?.withRenderingMode(.alwaysTemplate), for: .normal)
                }else{
                    cell.checkBtn.setImage(R.image.ic_uncheck_red()?.withRenderingMode(.alwaysTemplate), for: .normal)
                }

                return cell
                
            default:
                return UITableViewCell()
            }
        case 5:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Invite Friends", comment: "Invite Friends")
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Clear Call Log", comment: "Clear Call Log")
                return cell
            default:
                return UITableViewCell()
            }
        case 6:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Help", comment: "Help")
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Report a Problem", comment: "Report a Problem")
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Delete Account", comment: "Delete Account")
                return cell
//            case 3:
//                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
//                cell.titleLabel.text = NSLocalizedString("Logout", comment: "Logout")
//                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}
