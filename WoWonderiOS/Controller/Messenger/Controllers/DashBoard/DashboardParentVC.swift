

import UIKit
import XLPagerTabStrip
import DropDown
import SwiftEventBus
import WoWonderTimelineSDK
class DashboardParentVC: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var type:Int = 0
    @IBOutlet weak var topView: UIView!
    private let moreDropdown = DropDown()
    override func viewDidLoad() {
        self.setupUI()
        super.viewDidLoad()
        self.customizeDropdown()
        SwiftEventBus.onMainThread(self, name: "settings", sender: nil) { Notification in
            guard let data = Notification?.object as? Int else {return}
            self.type = data
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func nearByPressed(_ sender: Any) {
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1

        let vc = R.storyboard.findFriends.findFriendsVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func morePressed(_ sender: Any) {
        let alert = UIAlertController(title: "More Menu", message: "", preferredStyle: .actionSheet)
        let createGroup = UIAlertAction(title: "Create New Group", style: .default) { action in
            log.verbose("Create Group")
            let vc = R.storyboard.group.createGroupVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let groupRequest = UIAlertAction(title: "Group Requests", style: .default) { action in
            let vc = R.storyboard.group.groupRequestVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let BlockedUserList = UIAlertAction(title: "Blocked User List", style: .default) { action in
            let vc = R.storyboard.dashboard.blockedUsersVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let settings = UIAlertAction(title: "Settings", style: .default) { action in
            let story = UIStoryboard(name: "Settings", bundle: nil)
            let vc = story.instantiateViewController(identifier: "SettingsVC1") as! SettingsVC1
              self.navigationController?.pushViewController(vc, animated: true)
        }
        let ClearCallLogs = UIAlertAction(title: "Clear call Log", style: .default) { action in
            let callLogs = UserDefaults.standard.getCallsLogs(Key: Local.CALL_LOGS.CallLogs)
            if callLogs.isEmpty{
                self.view.makeToast(NSLocalizedString("There are no call Logs to clear", comment: "There are no call Logs to clear"))
            }else{
                UserDefaults.standard.removeValuefromUserdefault(Key: Local.CALL_LOGS.CallLogs)
                self.view.makeToast(NSLocalizedString("Call Logs Cleared", comment: "Call Logs Cleared"))
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        if type == 0{
            alert.addAction(createGroup)
            alert.addAction(groupRequest)
            alert.addAction(BlockedUserList)
            alert.addAction(settings)
            
        }else if type == 1{
            alert.addAction(settings)
            
        }else if type == 2{
            alert.addAction(ClearCallLogs)
            alert.addAction(settings)
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        
//        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
//        self.moreDropdown.show()
    }
    @IBAction func searchPressed(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    func customizeDropdown(){
        
        moreDropdown.dataSource = [NSLocalizedString("Block User List", comment: "Block User List"),NSLocalizedString("Settings", comment: "Settings")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
//        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                let vc = R.storyboard.dashboard.blockedUsersVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
              let vc = R.storyboard.settings.settingsVC1()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            print("Index = \(index)")
        }
        
    }

    private func setupUI() {
        self.topView.backgroundColor = .mainColor
        self.view.backgroundColor = .systemBackground
        self.searchBtn.tintColor = .label
        self.nearByBtn.tintColor = .label
        self.moreBtn.tintColor = .label
        self.nameLabel.textColor = .mainColor
        self.navigationController?.navigationBar.barTintColor = .mainColor
        self.appDelegate?.window?.tintColor = .mainColor
        
        self.containerView.isScrollEnabled = false
        self.nameLabel.text = ControlSettings.AppName
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .mainColor
       // settings.style.buttonBarItemFont =  UIFont(name: "Poppins", size: 15)!
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
//        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        let color = UIColor.systemGray
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = color
            newCell?.label.textColor = .mainColor
            print("OldCell",oldCell)
            print("NewCell",newCell)
            
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let chatVC = R.storyboard.dashboard.chatVC()
        let groupVC = R.storyboard.dashboard.groupVC()
        let storiesVC = R.storyboard.dashboard.storiesVC()
        let callVC = R.storyboard.dashboard.callVC()
        return [chatVC!,callVC!]
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
