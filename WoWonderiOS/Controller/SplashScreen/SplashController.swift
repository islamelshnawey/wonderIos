//
//  SplashController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/18/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let status = Reach().connectionStatus()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppInstance.instance.sessionId = UserData.getAccess_Token()
        AppInstance.instance.userId = UserData.getUSER_ID()
        // Do any additional setup after loading the view.
        self.activityIndicator.startAnimating()
        self.getNewsFeed()
        self.getSuggestedUsers()
        self.getSuggestedGroups()
        self.getMyPages()
        self.getmyGroups()
    }
    

    
    private func getNewsFeed () {
        switch status {
        case .unknown, .offline:
//            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            self.view.isUserInteractionEnabled = true
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: 1, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token() ?? "")", limit: 15, off_set: "") {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            AppInstance.instance.newsFeed_data.append(i)
//                            self?.newsFeed_data.append(i)
                        }
                        
                        self?.activityIndicator.stopAnimating()
                        let StoryBoards = UIStoryboard(name: "Main", bundle: nil)
                        let vc = StoryBoards.instantiateViewController(withIdentifier: "TabbarVC")
                        vc.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
//                        print(self?.newsFeed_data)
                       
//                        for it in self!.newsFeed_data{
//                            let boosted = it["is_post_boosted"] as? Int ?? 0
//                            self?.newsFeedArray.sorted(by: { _,_ in boosted == 1 })
//                        }
//                        self?.spinner.stopAnimating()
//                        ZKProgressHUD.dismiss()
                    }
                    else if authError != nil {
//                        ZKProgressHUD.dismiss()
//                        self?.view.isUserInteractionEnabled = true
                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error  != nil {
//                        ZKProgressHUD.dismiss()
//                        self?.view.isUserInteractionEnabled = true
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getSuggestedUsers(){
        switch status {
        case .unknown, .offline:
//            self.activityIndicator.stopAnimating()
            self.view.makeToast("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetSuggestedGroupManager.sharedInstance.getGroups(type: "users", limit: 8) { (success, authError, error) in
                    if (success != nil){
                        for i in success!.data{
                            AppInstance.instance.suggested_users.append(i)
    //                        self.suggestedGroups.append(i)
                        }
                        
    //                    self.activityIndicator.stopAnimating()
    //                    self.tableView.reloadData()
                        
                    }
                    else if (authError != nil){
    //                    self.activityIndicator.stopAnimating()
    //                    self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if (error != nil){
    //                    self.activityIndicator.stopAnimating()
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getSuggestedGroups(){
        switch status {
        case .unknown, .offline:
//            self.activityIndicator.stopAnimating()
            self.view.makeToast("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetSuggestedGroupManager.sharedInstance.getGroups(type: "groups", limit: 8) { (success, authError, error) in
                    if (success != nil){
                        for i in success!.data{
                            AppInstance.instance.suggested_groups.append(i)
    //                        self.suggestedGroups.append(i)
                        }
                        
    //                    self.activityIndicator.stopAnimating()
    //                    self.tableView.reloadData()
                        
                    }
                    else if (authError != nil){
    //                    self.activityIndicator.stopAnimating()
    //                    self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if (error != nil){
    //                    self.activityIndicator.stopAnimating()
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getmyGroups() {
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetMyGroupsManager.sharedInstance.getMyGroups(userId: UserData.getUSER_ID()!, offset: "") { (success, authError, error) in
                    if success != nil {
                        print(success!.data)
                        for i in success!.data{
                            AppInstance.instance.myGroups.append(i)
                        }
                        //        self.myGroups = self.groupList.filter({$0["user_id"] as? String == UserData.getUSER_ID()!})
                        //            print(self.myGroups.count)
                        //        self.groupList = self.groupList.filter({$0["user_id"] as? String != UserData.getUSER_ID()!})
                        //                     print(self.groupList.count)
                        
//                        self.tableView.reloadData()
                    }
                    else if authError != nil {
                        print(authError?.errors.errorText ?? "")
//                        self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getMyPages() {
        switch status {
        case .unknown, .offline:
            print("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetMyPagesManager.sharedInstance.getLikedPages(userId: UserData.getUSER_ID()!, offset: "0") { (success, authError, error) in
                    if success != nil {
//                        self.myPages.removeAll()
                        for i in success!.data{
                            AppInstance.instance.myPages.append(i)
                        }
            
                        }
//                        self.activityIndicator.stopAnimating()
//                        self.tableView.reloadData()
                    
                    else if authError != nil {
                        print(authError?.errors.errorText ?? "")
//                        self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }


}
